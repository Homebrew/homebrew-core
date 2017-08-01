class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://download.sourceforge.net/libpng/libpng-1.6.31.tar.xz"
  mirror "ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.31.tar.xz"
  sha256 "232a602de04916b2b5ce6f901829caf419519e6a16cc9cd7c1c91187d3ee8b41"

  bottle do
    cellar :any
    sha256 "9d9e460b53e55171611658d7fbbbf95a0adcb85f8a61a1144bcc3e9214cb58d7" => :sierra
    sha256 "3accfdf2130296f56a07fa901c144f7a05bba62df0b806a78c598eeca5c355e4" => :el_capitan
    sha256 "73ec98b55afc2a098e20668ed51a77d337bf7268308eb29e438b63a58af93c8f" => :yosemite
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
