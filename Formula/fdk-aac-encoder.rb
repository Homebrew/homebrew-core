class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v0.6.3.tar.gz"
  sha256 "16ad555403743b0d288fd113b6d8451a4e787112d4edbfd2da36280a062290c6"

  bottle do
    cellar :any
    sha256 "786e3ce4a555ea473a8915df451f51ad81f5c27749c29b1e87e64d80c799588f" => :sierra
    sha256 "4a157e1d1f0f69db4c8070dd0f9c48e5099710aa516c41a3db83c25a0c84adb6" => :el_capitan
    sha256 "03fbc5fed2792b358a9bf8e777678bbfca219cb8c9e969b6e3a6c5292de7b65f" => :yosemite
    sha256 "1232969391e4d3efa420638de1724313ee56b06397b8f730af0e608609b6ba05" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fdk-aac"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # generate test tone pcm file
    sample_rate = 44100
    two_pi = 2 * Math::PI

    num_samples = sample_rate
    frequency = 440.0
    max_amplitude = 0.2

    position_in_period = 0.0
    position_in_period_delta = frequency / sample_rate

    samples = [].fill(0.0, 0, num_samples)

    num_samples.times do |i|
      samples[i] = Math.sin(position_in_period * two_pi) * max_amplitude

      position_in_period += position_in_period_delta

      if position_in_period >= 1.0
        position_in_period -= 1.0
      end
    end

    samples.map! do |sample|
      (sample * 32767.0).round
    end

    File.open("#{testpath}/tone.pcm", "wb") do |f|
      f.syswrite(samples.flatten.pack("s*"))
    end

    system "#{bin}/fdkaac", "-R", "--raw-channels", "1", "-m",
           "1", "#{testpath}/tone.pcm", "--title", "Test Tone"
  end
end
