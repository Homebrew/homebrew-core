class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.3/libgd-2.3.3.tar.xz"
  sha256 "3fe822ece20796060af63b7c60acb151e5844204d289da0ce08f8fdf131e5a61"
  license :cannot_represent
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08396f5ebf194ac40aee435158ccfa5405f214c5dbcf37bf6e253c1bd085123a"
    sha256 cellar: :any,                 arm64_big_sur:  "6c7673cab6618b0a9e0d41531150d65c8eebd1f252c17dba38ad0f44790f6828"
    sha256 cellar: :any,                 monterey:       "570313a4b9170b71de90d87c66d638beafe6aca33c919a0a3864f750e1e65599"
    sha256 cellar: :any,                 big_sur:        "7580452407899ec5ba045a9d48af158bbefa50a5b561b826ae2ac845119dfac7"
    sha256 cellar: :any,                 catalina:       "23cf2d9d302fdadd217d1a6c2f9a10f32090bda59f0202a657b3af4eec59ff2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "760128cc65a8e50be67fd0c8f29b307dc89886ed2b7a66f9cf40db5d1d03e5c3"
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
