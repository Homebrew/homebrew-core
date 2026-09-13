class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "25baf7bd9ae697d1c2673bbf4b1348b337258ef487c2bd0572451539fb38ebbf"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f952dcb8b1bc61bf37823f260ef34963eac94c1bbbf61379a7a030a38e514bfc"
    sha256 cellar: :any, arm64_sequoia: "1c50e168412d30b559d0b7cff2d4518e338587325d5c8bb385c7697bd88c90d2"
    sha256 cellar: :any, arm64_sonoma:  "4ee04bad740054d2561e3e34e1d7951be26b0001138a031848ee204cd676731f"
    sha256 cellar: :any, sonoma:        "4bae4364679f2308ae95be36c8507849bc7257c08132aa41efc7d59617cb1c05"
    sha256 cellar: :any, arm64_linux:   "fccd66297f7bc52329e067b0211ff1feebe6c0f43b2d787d4bc8150b18307be5"
    sha256 cellar: :any, x86_64_linux:  "68e96ebd500150e702b69b0d741f6297320bec4766a4c9c4af6fc9e585dc4d27"
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
