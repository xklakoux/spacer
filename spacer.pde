import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;

void setup()
{
  size(512, 200, P2D);

  minim = new Minim(this);
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
  
  fft = new FFT(in.bufferSize(), in.sampleRate());
}

void draw()
{
  background(0);
  stroke(255);
  
  fft.forward(in.mix);

  // draw the waveform and spectrum
  // It is in two loop for eficiency reasons, first it draws waveform and spectrum, which is ~2x shorter.
  // Then in second loop it finishes only waveform.
  for(int i = 0; i < fft.specSize(); i++)
  {
    line(i, 50 + in.mix.get(i)*50, i+1, 50 + in.mix.get(i+1)*50);
    line(i, height, i, height - fft.getBand(i)*4);
  }
  for(int i = fft.specSize(); i < in.bufferSize() - 1; i++)
  {
    line(i, 50 + in.mix.get(i)*50, i+1, 50 + in.mix.get(i+1)*50);
  }
  
}


void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
