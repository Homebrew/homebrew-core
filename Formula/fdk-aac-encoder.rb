class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v1.0.2.tar.gz"
  sha256 "8a0b67792605fb8955d6be78a81e3a4029e9b7d0f594d8ed76e0fbcef90be0c8"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f6f1db7001098e01b65cbf58a080895930b2e2fa51661a3554728c0edb6466da"
    sha256 cellar: :any,                 arm64_big_sur:  "50284ef03649e17c800e516cb0f8bcbfc97f891e042e0e84b4e7c91495fcdb0d"
    sha256 cellar: :any,                 monterey:       "dc1daeb7c994fe9f18b22c69e14bd3cecae40112a517974808ab898d84651142"
    sha256 cellar: :any,                 big_sur:        "32240adad3bc3e6fe29d1c6a29909024a203aaa5167fd4a93b8b4383edb65186"
    sha256 cellar: :any,                 catalina:       "c4da455a74f28dd39f1c2be168cc08711921c00a7fe2fc2779b80eb57e96af29"
    sha256 cellar: :any,                 mojave:         "09c58b1dac4628d28a357542d9af2e000067804ad0523ece1121016172626c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90035c40a5fe78912b589404d5cf5c28ac2c807d5299e681def8e29226d15d8e"
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
