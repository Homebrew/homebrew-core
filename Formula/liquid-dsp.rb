class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "http://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.3.0.tar.gz"
  sha256 "b136343d644bc1441f7854f2d292bfa054e8d040c0b745879b205f6836dca0f0"

  bottle do
    cellar :any
    sha256 "8e7b1160f024f19378c9fd386af3541e4da4ba8ebde11096349494cd4d11a5e9" => :high_sierra
    sha256 "6eb6aa0308c4a5dfc973050c40ff9883973ee95e3c888940e085268c99d75ad2" => :sierra
    sha256 "abe5249107bf62da919048602306d41890417ae1153614e6ea2705fff85fefec" => :el_capitan
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
