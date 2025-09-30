class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "33c42ebc2e6088570421e282c6332e899705d42b4f73ebd1212e6a11da714dd4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de67d0f577325b67c1130c3c0b851da268184c5b0d7110f61dcaa24166dc6a74"
    sha256 cellar: :any,                 arm64_sequoia: "b8a80ea89fa4390be08e71b263f9117e094277ca8832db34a2ade2acc4442766"
    sha256 cellar: :any,                 arm64_sonoma:  "1959fe41645657d0d27b65a27e4106b8ebb7453b6b4933dc89f4e971df308c1d"
    sha256 cellar: :any,                 arm64_ventura: "ef0b0fffea38cbbd424d1cea2398c998f62fc1b000bd990217fec502b25514d8"
    sha256 cellar: :any,                 sonoma:        "45c2eacbc105dc60a05650f8a26b1030d8d68f2e1ad5658b3aac69e55a935fac"
    sha256 cellar: :any,                 ventura:       "034053ad567403a05e58d450dc7d5c717a663f1ed8e2f46dfebe0a3e4830c70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17cc4d0a408358eaa7c80819e7ac7ba89142626be83feeea495252b0b73a0653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677337e96a58a18d51ac014d4471b111a0b00ce735eea54cc1a788fac95cccd1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  # Backport fix for ARM64 Linux
  patch do
    url "https://github.com/jgaeddert/liquid-dsp/commit/3a5e1f578ad5e73d7665e71781e764765608c2a2.patch?full_index=1"
    sha256 "8dcece1e5e612b5dad77030dfd453f0f47755fdb41e6201c0c8b6b7123f053b9"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end
