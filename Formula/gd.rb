class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c625bf1de35375334370901cfb5283b169253a2616e2cd7c5299a110fe07672e"
    sha256 cellar: :any,                 big_sur:       "2c746f463d1b0ceaa2a9986b9ace87da6ec8b99b1a1362383d2375b067dc7010"
    sha256 cellar: :any,                 catalina:      "aa93cd58d9694c86299445e73750e41b5740bc6ea5b247032ed3c71eca5cbce4"
    sha256 cellar: :any,                 mojave:        "59e7dada9e961a52a5db6d14ad39985310bd6dfdbf4b9a4a321280d880b110bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9fb3455b4efc573420ba78f8d54a3413e9079438f27930fd342d15d0e16852e"
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
