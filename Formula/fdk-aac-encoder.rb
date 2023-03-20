class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v1.0.5.tar.gz"
  sha256 "87b2d2cc913a1f90bd19315061ede81c1c3364e160802c70117a7ea81e80bd33"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "53ead014ba7ed33292482be014d74bc631fc64a9027f7ae6a5858b66e51cef24"
    sha256 cellar: :any,                 arm64_monterey: "df8bf96255c43057c312a4062aa386d1dc136c0dd86094c7d9cd067120b57ee4"
    sha256 cellar: :any,                 arm64_big_sur:  "66c2be632e6ba93f7fd30d43ff968edfed911d104e14d8a43b86b52cf8d78719"
    sha256 cellar: :any,                 ventura:        "cfaf04fdeffda1f429b28ee0dd84914768f4339007a14999415aae8eea232051"
    sha256 cellar: :any,                 monterey:       "02f940f3b2a982e8f727cb9a449623777e33de70d41ad43423462aafe6db0ad0"
    sha256 cellar: :any,                 big_sur:        "aab1624f88d3b7b0b0c3ae2e772ee86efd4b6707468a78d43459a598920eb053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd87f32244ba80edb9825fa589570d8591f6ce337aa994025ad04f221f545f7"
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
    two_pi = Math::PI * 2

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
