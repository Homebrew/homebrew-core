class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v1.0.1.tar.gz"
  sha256 "ce9459111cee48c84b2e5e7154fa5a182c8ec1132da880656de3c1bc3bf2cc79"
  license "Zlib"

  bottle do
    cellar :any
    sha256 "2bb1d960c47fca61a9b677314b64dc2ab1311111c7b36818a46e47aa13bcc675" => :big_sur
    sha256 "cb07e4fec67df342a3a6d9cae8d40e9a2d8436618c4b11f1183145d1eb01faa4" => :arm64_big_sur
    sha256 "ce0c1d5ff1bc3cc3483d2602fdbb1f3f0e6b8124c821f13f7d22c931bdd64303" => :catalina
    sha256 "251c3f283f5bf30c69b05b69fb80e3ef497d17d0f3290e1d11021d51950910ce" => :mojave
    sha256 "6bd9626cca01c6d07b55143acd321676a573f68ba2ec7734922b936332fab567" => :high_sierra
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
