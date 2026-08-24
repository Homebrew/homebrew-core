class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "be6de0851c447d132e9bff0141068ee6fec6d37e21973ea9304480c68178058b"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1c1fa5d09f586ff7e3f04ef45245f493528edb401ce03e83f85eac867f5a7fd"
    sha256 cellar: :any, arm64_sequoia: "0ae138a3038c2e26515b4dc174562beb546fcd2e521dbccb1cd0f1f71ead14a0"
    sha256 cellar: :any, arm64_sonoma:  "368665916e8f662bf0ae024e7b2f0ae156e8b6af164043bcb2726bc88f909563"
    sha256 cellar: :any, sonoma:        "e161eb23fead9c0646bf359bc34052e93dc4103c09245c40c848e107e0f4c47c"
    sha256 cellar: :any, arm64_linux:   "b2ecbe10dbeb30842b8fc1ba8ad168677efdf5e76d8c7848c4b55b9b408e7aff"
    sha256 cellar: :any, x86_64_linux:  "e20859b8cd9a5fc3095f7b63fa0c7b6a1ce0147958ca93a043e6ce84b510532f"
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
