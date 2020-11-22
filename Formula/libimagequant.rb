class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.13.1.tar.gz"
  sha256 "1f46deec3fa280335cf7f0be3ede6006bb420ba8159a03d1f6938e8d283d03ae"
  license :cannot_represent

  bottle do
    cellar :any
    sha256 "d6541acf2369f7e438c935f1d6e560e1be686a556de7d9160f9628b3ec44549e" => :big_sur
    sha256 "cf22020efa8a6816521877e04ac132876ab81362bb5e28b992ddfa76f3d9a228" => :catalina
    sha256 "cfffbc501d8bf39d8305421921f0ec4d727f7bb5548481e9e4908164b0c45db0" => :mojave
    sha256 "ddb7eba89c6e65024e72c9cb3272b7c4f7edc0f5b54eb232ebce9f958e8a6480" => :high_sierra
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
