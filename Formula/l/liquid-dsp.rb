class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "6ee6a5dfb48e047b118cf613c0b9f43e34356a5667a77a72a55371d2c8c53bf5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8399cfcbc22e0e179328bb4af7fdc62c0be4870859cf7177e3932529bb839cd4"
    sha256 cellar: :any,                 arm64_sonoma:   "779e71883f2c2dc3796dcbdb4a3e4666c4c47af8866571527a74965fec71ca50"
    sha256 cellar: :any,                 arm64_ventura:  "85cec9c7750eaad377d06d956da6dfdcb6534e2c5f9af1f21e361facbe4e4132"
    sha256 cellar: :any,                 arm64_monterey: "c86833a699c1b9d9959690b89487d5837efb089c4d15b5242f477380bb817406"
    sha256 cellar: :any,                 arm64_big_sur:  "9e197584353048f6a5a4e0758ec8954dcab3aa38c47c3e15d44370c06cdbb4ef"
    sha256 cellar: :any,                 sonoma:         "5139f2f8f811fd8a218dc6c113b20ec4132f6f99e640ad9a607314b8b0f6e2c1"
    sha256 cellar: :any,                 ventura:        "3fa3ac40a8a63f6992f0850783471f41cd83278948ff2db41070af513563e5bb"
    sha256 cellar: :any,                 monterey:       "fc61c2f3f2bf3012d8ea3d5e7b90c9df1386c658752b469b2bebf0c02b9d0d79"
    sha256 cellar: :any,                 big_sur:        "79aa0163d2a7ccb9acdd491b4b80600a7e65624bdda7000460d88684163188ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a10eed9b58eb7c8106232e2d954f5c05de72b60d1b967f7ff703e97f9636e27c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end
