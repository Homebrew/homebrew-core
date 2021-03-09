class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.14.1.tar.gz"
  sha256 "b5fa27da1f3cf3e8255dd02778bb6a51dc71ce9f99a4fc930ea69b83200a7c74"
  license :cannot_represent

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b1b6b13823a3a8590dc94296c891c447a1aec3f17f2d0847b33c9bb3cb25ccf3"
    sha256 cellar: :any, big_sur:       "e0cc2ed03f455bed35c3cf56c897c3430efa22d6b0646e083b41ec253248fdf8"
    sha256 cellar: :any, catalina:      "eed2b90a2cbeb0394177056b5f6d1b4776b0051439526c4e826e8e5cc6ceebaa"
    sha256 cellar: :any, mojave:        "7d3930509859c89f13b0c9adf1c50615241b839a96be746bbce9bd6e3e35f236"
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
