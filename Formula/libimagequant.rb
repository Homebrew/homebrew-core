class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.12.3.tar.gz"
  sha256 "2bd7854657a7e52416cd9dbfc68f10a843b003950f06e74a0e51fc6de48ff13d"

  bottle do
    cellar :any
    sha256 "c919e2e35b45ac254ef89f7814008e0853ebbb3c7667fd59faeba48053229381" => :mojave
    sha256 "6d9b45f1f14578e535629c34e4c00e02c17bb1c458497643862bc31ee1733482" => :high_sierra
    sha256 "6ac28acc45709423a85a8741ac36c4a54981de3545ca070c0672ab95aecf776a" => :sierra
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
