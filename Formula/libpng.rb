class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.26.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.26/libpng-1.6.26.tar.xz"
  sha256 "266743a326986c3dbcee9d89b640595f6b16a293fd02b37d8c91348d317b73f9"

  bottle do
    cellar :any
    sha256 "f9215a039025176328cfbeb979cca738b752a19d51df43d6c9c23b0535699d6b" => :sierra
    sha256 "2c1f289bbb1013a8a71a3547e26d2d6bea709fc3d9e918a0ec7eb728ee126919" => :el_capitan
    sha256 "5d77f5f8e1c4f08a47fa555a15f5265f4429c2c732ef11f7802be562e4ec99ee" => :yosemite
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
