class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.12.5.tar.gz"
  sha256 "9dc07f3bf6efaf03241fd514e62108be484a373871e2e02c117e6efb49d26293"

  bottle do
    cellar :any
    sha256 "1768d6878f969fd4cbbdf6830c782f7e3b887b4d8beca4bb68f9c1c34d122261" => :mojave
    sha256 "94d0ba08c80540ccb2c1ceb9cc1f3789552009c9d434a269653dc3ee20694320" => :high_sierra
    sha256 "251d006da27a04ed67b840128aee8cce82aa0a8845d6732123cb7ce5ae8dee22" => :sierra
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
