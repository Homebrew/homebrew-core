class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.12.5.tar.gz"
  sha256 "9dc07f3bf6efaf03241fd514e62108be484a373871e2e02c117e6efb49d26293"

  bottle do
    cellar :any
    sha256 "a561ba2e4c04b37f8d0c16496ae899a141b9fb1bfb3ced50b9cd709c351794c7" => :catalina
    sha256 "a9a44c0f9814c80901275cd445a1f486baef051995f705a892f86e996b5b77e5" => :mojave
    sha256 "df578637695ae03e889b50b95403bf09911a94c6cec655042d949a6b139e5ee0" => :high_sierra
    sha256 "dffe189a48b03eae632e79f1970786b6c4f41525e5ed9e9c5ca5239fbcf05d30" => :sierra
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
