class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4d367cecad55958b4117d012f8e358922248ac5f3894fdf0fffbefe2312814a"
    sha256 cellar: :any,                 arm64_big_sur:  "6ce670e95834eda72a26d28f515f27becfe55b03ede20a3c4ee5f15fd9c0e687"
    sha256 cellar: :any,                 monterey:       "8976ef6710a704e27557e1ad9c2b3aecf9b0b3dc266b212922a6ac2226d0074d"
    sha256 cellar: :any,                 big_sur:        "35d040a24b8e6a05dee0703bef87a76d6c5d460a4168c749c484ecfc16d9904b"
    sha256 cellar: :any,                 catalina:       "40ea66d7bca0bb527ba6ffff45b503ef6d6a3bb520d18e12efd15233e41da50d"
    sha256 cellar: :any,                 mojave:         "33f5ac492e525bdfeb8f7602c1a56ed37e2f6f286e24734e406f568bc1be5d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8052fd3f49e14af727cff5f2f2227a0f6a5b3e9f0b1c1418b68cc86edabe5b52"
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
