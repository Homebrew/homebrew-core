class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "145d4684c9325a2bd650e46a04b03327abe780a7b59cce47e6de8af2064fb2c7"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3d5a36246ed05cf712710c26bcba7d88570d9733386d834c26027b813cf460e"
    sha256 cellar: :any,                 arm64_sequoia: "7e8347597d693ddc8bd3dfb7d2fad8e3f2a1a454e41a18eeba31ea79a2f9aa80"
    sha256 cellar: :any,                 arm64_sonoma:  "0cccceea0402d98a415aa93a87420b8c9f4f71393ee1df58b7bcffca62961a24"
    sha256 cellar: :any,                 sonoma:        "e83a70330bbecdc9ad66cddd891181153b0836edae4d78b52193c948aab787a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0999a7c5a7ec6ecd3d42625860b83857cac894b7b333bc24bbbf4f5d2f2685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c138775cc930815e191b15a0c09a3df618be38832db32eb234c58e0cb1b6085"
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
           "1", testpath/"tone.pcm", "--title", "Test Tone"
  end
end
