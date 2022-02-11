class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8b02b582f999c504b656184aec72c1e5ee3e1f443ea2bed1195051af9d7938f8"
    sha256 cellar: :any,                 arm64_big_sur:  "51c8942dcbcb0e57422efca417690f5fb268b05cb61a9c71b4eabf41547128d9"
    sha256 cellar: :any,                 monterey:       "9a2d77f89bfc016eed59dcfb103009644fa6b60b12f736b7f87daaf40672b50b"
    sha256 cellar: :any,                 big_sur:        "9e56662c33e3584d442e383eefc14b928f706c2b9b7750ca40c2bf640b349ae2"
    sha256 cellar: :any,                 catalina:       "04e25cf024186191731fd94808802bb1a1dd7dfb900d963abc1ef8737abb53e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "180a1fcde66b5ddf8beea325c1c82e3b974e15da56fba22b0a0d4b503d593f83"
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"

  # revert breaking changes in 2.3.3, remove in next release
  patch do
    url "https://github.com/libgd/libgd/commit/f4bc1f5c26925548662946ed7cfa473c190a104a.patch?full_index=1"
    sha256 "1015f6e125f139a1e922ac4bc2a18abbc498b0142193fa692846bf0f344a3691"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--without-x",
                          "--without-xpm"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "gd.h"
      #include <stdio.h>

      int main() {
        gdImagePtr im;
        FILE *pngout;
        int black;
        int white;

        im = gdImageCreate(64, 64);
        black = gdImageColorAllocate(im, 0, 0, 0);
        white = gdImageColorAllocate(im, 255, 255, 255);
        gdImageLine(im, 0, 0, 63, 63, white);
        pngout = fopen("test.png", "wb");
        gdImagePng(im, pngout);
        fclose(pngout);
        gdImageDestroy(im);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgd", "-o", "test"
    system "./test"
    assert_path_exists "#{testpath}/test.png"
  end
end
