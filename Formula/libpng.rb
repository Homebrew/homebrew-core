class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.23.tar.xz"
  #mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.23.tar.xz"
  sha256 "6d921e7bdaec56e9f6594463ec1fe1981c3cd2d5fc925d3781e219b5349262f1"

  bottle do
    cellar :any
    sha256 "3541069a9d95047d6161faa97188e91b4a909e97e53d086f16df3334aa5058e8" => :el_capitan
    sha256 "939b1d2021184400ae922e00e1aa46e64086e38aa0528ba8a4ed914c4657b020" => :yosemite
    sha256 "13579594cd7c3fb74da78632217ff8716ab52c485d687b9457c67f11d6daa8cf" => :mavericks
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
