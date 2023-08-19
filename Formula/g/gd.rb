class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e23180f273c11082a722aad683c929c3cb27acede6b5274c0ddcede895287a0"
    sha256 cellar: :any,                 arm64_monterey: "1aea67a3b927c0955a10126c92ed167932098eb47c991e485fad3c3add358519"
    sha256 cellar: :any,                 arm64_big_sur:  "4a65d1f0fed5462bd621cfde772689fc4ca18ce7ae610f4c0fe69860217c256c"
    sha256 cellar: :any,                 ventura:        "86166efda1448a1dbc605d11751ed2194858db85ac14eaf2071d94ebbe11ecb1"
    sha256 cellar: :any,                 monterey:       "08514ca3262da9bf44c5f332713fc20f2e14a7ea22ae6e853829b06da09480c7"
    sha256 cellar: :any,                 big_sur:        "14ebdc0e93c087250ee130dc67de4082f26cd74428dddc047cfa834cc750230e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb25e79ae81750ac775514100a9f0d404438f8499cdc8b6b60b3d3f2b5411a4a"
  end

  head do
    url "https://github.com/libgd/libgd.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
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
    system "./configure", *std_configure_args,
                          "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-jpeg=#{Formula["jpeg-turbo"].opt_prefix}",
                          "--with-avif=#{Formula["libavif"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-tiff=#{Formula["libtiff"].opt_prefix}",
                          "--with-webp=#{Formula["webp"].opt_prefix}",
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
