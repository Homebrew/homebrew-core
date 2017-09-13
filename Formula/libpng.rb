class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://download.sourceforge.net/libpng/libpng-1.6.32.tar.xz"
  mirror "ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.32.tar.xz"
  sha256 "c918c3113de74a692f0a1526ce881dc26067763eb3915c57ef3a0f7b6886f59b"

  bottle do
    cellar :any
    sha256 "53c8fa0a036f36a0a01aaee8ab7138ee8bb1f436c0fec9c372f138b9840d5729" => :sierra
    sha256 "7ecb31ca907099430fbc4820b10f2fcb61b1a5f34ac7ceb7667b0295742485f2" => :el_capitan
    sha256 "01681368a1f310130415d4488772864bb22e0565c31ee4f6a9b491baec94210d" => :yosemite
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
