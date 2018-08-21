class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.12.1.tar.gz"
  sha256 "7035eb281bc9a49cf36db8db807b713d03a0ffe8c5abfbb17a9ea8a038f21d5e"

  bottle do
    cellar :any
    sha256 "f7d95445314ffdca4ec26f8386d8401357eadc0e171478d3439ddb356b4b57c0" => :mojave
    sha256 "714cab630af0e9d0e19ad0a30a1e07b4dfce3988f9c048e3b634cea85c018ec6" => :high_sierra
    sha256 "41aa19e02e531883c60360556f94d404fb6be00bcb8b4c155368ec34c190ad10" => :sierra
    sha256 "908ec28bdf4879c7527053bbec4b635e0cbb4f7c635251674e8f1723b4e16cd6" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
