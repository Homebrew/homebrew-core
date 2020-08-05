class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.12.6.tar.gz"
  sha256 "b34964512c0dbe550c5f1b394c246c42a988cd73b71a76c5838aa2b4a96e43a0"

  bottle do
    cellar :any
    sha256 "31bc66699e19c2874ace33dc919782b6effefa53bdcb6bfe804f954e9d4df1bf" => :catalina
    sha256 "65b36c32d15e2605ab813007436090f2004c50062dd68a806fe324e832f62e06" => :mojave
    sha256 "9f2444bbeed8e96b5a575dd6d9168330f5aa9609aae13919eb50576d2b93e994" => :high_sierra
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
