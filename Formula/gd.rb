class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "62e2d11e1a556084beab6320187c522647cb15308233f164d9fe1e177701d37f"
    sha256 cellar: :any,                 arm64_monterey: "22dba9b654ae0a2907e77fdaff796412da28510243b75df5a2685b3e9339d7b3"
    sha256 cellar: :any,                 arm64_big_sur:  "cfdb218c7e0327c118eb6b780ce42b0b833dce71f835990736d184207169b885"
    sha256 cellar: :any,                 ventura:        "ec3bd984449c58ff41f82debb5b98e83d8fd275b345504fab99f65e780b10085"
    sha256 cellar: :any,                 monterey:       "220d7e3cd2bef8d4b61f7bc6b636f4eb09e8b0959dc55faef033e6b3ceaddc04"
    sha256 cellar: :any,                 big_sur:        "8e860ba44781f2456886c506d1f83806007a3962f12a6e5f5bdc85948be1b9b4"
    sha256 cellar: :any,                 catalina:       "541e1b5312cbbcf65c62557da84771a78f689fde33e355233c44b637ef5b04ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523b01e8bfe6bfdb5d405b9d9d44567d99bd2d98e51b82c1b936e1e85f8c0195"
  end

  head do
    url "https://github.com/libgd/libgd.git"

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
