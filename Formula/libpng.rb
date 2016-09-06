class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.24.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.24.tar.xz"
  sha256 "7932dc9e5e45d55ece9d204e90196bbb5f2c82741ccb0f7e10d07d364a6fd6dd"

  bottle do
    cellar :any
    sha256 "477a8ef8128486787aa00ebeafb19e7b5b50dffbdb11f2c8d851e05f7b982943" => :sierra
    sha256 "92ae818d3a0237f375767d2f0ce673484789ca298b7295cf34c48da945c0dc3f" => :el_capitan
    sha256 "d0c673c254660fbce4880f74a6d832f6ce5ce4bd4926ea2e7e0985cb0ac82218" => :yosemite
    sha256 "91e832b62a0ee289d3835edbffdd7fccb4d5674c7a0d4c1c6ac1d367584b02c4" => :mavericks
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
