class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.29.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.29/libpng-1.6.29.tar.xz"
  sha256 "4245b684e8fe829ebb76186327bb37ce5a639938b219882b53d64bd3cfc5f239"

  bottle do
    cellar :any
    sha256 "2600fdd23d57d1482d80f67e318e317ce15440f80f1b246ab75ad05ed39d902c" => :sierra
    sha256 "a73d91c9a5f5cbbf18c07f9aab3a40ca0d4d06adb27cd81e89c9d74e9224cb68" => :el_capitan
    sha256 "950076f466ffdfffc3712e74010026f607ddb74dc7946bf782ac605610741aac" => :yosemite
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  def install
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
