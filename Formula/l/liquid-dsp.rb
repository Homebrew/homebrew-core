class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "a0adbc3ec5630d620a55351285573f59948153a14c703fb64b4ad58989bd6e2f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7343ee4fb9ed2fd13c44e2b4a9c650859053e5f5a657b6b915e56c9cbaf67e12"
    sha256 cellar: :any, arm64_sequoia: "69d3a9c0585fe4ede3eb3a0ad032a5475c5850006f6bc86e8fd9421e07a36d99"
    sha256 cellar: :any, arm64_sonoma:  "d89e0450a415d85035b747dee40bbf35f94fbfeb424a0eac46cf48fe66a6d2ee"
    sha256 cellar: :any, sonoma:        "a3f5662e3479f98ae19c3a7b5bbe12bfae4f15d3394bdb469ac8870006fca999"
    sha256 cellar: :any, arm64_linux:   "392c4cd0fe640c8d1c7f558d712d23eda5db1beab4716ea1c3983af46c617324"
    sha256 cellar: :any, x86_64_linux:  "2f62b8fc4eca6a99cbca6031800d414be09d534a4f39b99f587363a344b8383c"
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
