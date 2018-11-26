class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/1.0.0.tar.gz"
  sha256 "1cb1a245d3b230d9c772e69aea091e6195073cbd8cc7d63e684af7d69b495365"
  revision 1

  bottle do
    cellar :any
    sha256 "625b44542938aed259728a61cde68d3ed035132ab1e0cc41b241769caebbcedd" => :mojave
    sha256 "37f34d998eb6cc54f6b49d1abfdf7e0e4d256c98764f36e8befce86ee118dcbf" => :high_sierra
    sha256 "2ae9013ce4ba2137734d76d6b9911b65cc16a90e4499b582973bc045e9c931f2" => :sierra
    sha256 "eb1aadd4cd6b6d6982854b351703e175fd683ebc81f16e5f98858ee38c0675e0" => :el_capitan
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

      position_in_period -= 1.0 if position_in_period >= 1.0
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
