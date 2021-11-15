class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.16.0.tar.gz"
  sha256 "360f88a4a85546405e6bec36d403cedfda43e7b8b5ec140216b727a05cd3a8ac"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35423a63c3283e14bcaec06895fae8b8cb3a212b10b525801ebad7aa8fcc28d4"
    sha256 cellar: :any,                 arm64_big_sur:  "065f7d7435bc68b1b7cd8fcdc4bb94729c57ed6460c64c06831a89d1fa3124b8"
    sha256 cellar: :any,                 monterey:       "7d79b0423ff78598d9115c552263123a09c37f6383b61307c399ecb7bb904aa0"
    sha256 cellar: :any,                 big_sur:        "c146b4b854f70a30e3826d982029521bdd0d7a9c989566a91be7b5c14725070a"
    sha256 cellar: :any,                 catalina:       "65932be7e1b594d4ee80c8c6b36d78667fe8a3c9d0950e8ff0e408b750c25ac0"
    sha256 cellar: :any,                 mojave:         "5796035b123ac2f417ead25f21c6e08357b87a48fa4f69dc3bcf6a2c3311fa92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d7e048e1fb0ea7f4c19950a44f9592976bb4e42cce429af7788d2a124b61129"
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
