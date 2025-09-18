class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "ed34c8dcae3d49d385e1ceaa380c5871cda744402358c61bcb49950a25bfae58"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e89af6a6d4d3cbfc2a5e312ca4a0f5d5eb74205fa9d328e2b8e1f197680c9779"
    sha256 cellar: :any,                 arm64_sequoia:  "7984a593915d70746aa5802b6f4232ad56c5c5329192197fa10a45a7c4f09266"
    sha256 cellar: :any,                 arm64_sonoma:   "e9e4f37acb4d76dc6139145cacc2c1d9799104c60ee43d650f63f1ff6bf96b94"
    sha256 cellar: :any,                 arm64_ventura:  "fece94f860394daafbacfb656ea28592bd0f482b12227335952f84852b011094"
    sha256 cellar: :any,                 arm64_monterey: "09cd0ffbcfe2e83c3526a2ea97ae7fac02085c4682938f2714291ce09a1d0dd9"
    sha256 cellar: :any,                 sonoma:         "99f243a63d88d1350bc798ca8f90ed703485462aa7a99b92588aafecd2867874"
    sha256 cellar: :any,                 ventura:        "4cc459e64c6b70274d477f223911b3f4cef20646920cd6f365d0992faae184c3"
    sha256 cellar: :any,                 monterey:       "93b808efe4acbd0d60c1990acd03b8eebd5308c8c59350f8bd13394423a7baa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b941b4a0be48f5ec58726a7f25547007f8085683a8b060ad24552532bd0880e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d3bcffd33552747f8c107a46e42f3cff7b500647fd2f268d688bee77ef711aa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "fdk-aac"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          *std_configure_args
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

    (testpath/"tone.pcm").open("wb") do |f|
      f.syswrite(samples.flatten.pack("s*"))
    end

    system bin/"fdkaac", "-R", "--raw-channels", "1", "-m",
           "1", "#{testpath}/tone.pcm", "--title", "Test Tone"
  end
end
