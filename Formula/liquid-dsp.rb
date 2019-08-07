class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.3.2.tar.gz"
  sha256 "85093624ef9cb90ead64c836d2f42690197edace1a86257d6524c4e4dc870483"

  bottle do
    cellar :any
    sha256 "f8f9a384db2f8832e7f31fa61223a3119a9278d9d6af8a2b11b6ec76c477edad" => :mojave
    sha256 "5d12243dc96220b6cc34ea32e440c91fd99c9e39f91f08afbbdd889005d06ecd" => :high_sierra
    sha256 "d58108029dc01dbf26931044f74afcf75d81b7de867fc1904e281ea02acd2dfe" => :sierra
    sha256 "8e979793bbc8c8101195a9107d1be8d10f6809d14982eb4e464019cf1914f577" => :el_capitan
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
