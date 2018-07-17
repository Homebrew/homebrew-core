class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/libpng/libpng-1.6.35.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.35/libpng-1.6.35.tar.xz"
  sha256 "23912ec8c9584917ed9b09c5023465d71709dce089be503c7867fec68a93bcd7"

  bottle do
    cellar :any
    sha256 "d38a64089526ecc1413acbc22373821fd181442b80ffccfd8322a5724dc09759" => :high_sierra
    sha256 "d587603b3079fb7ad5cecdd451ee7fdf88f80a8b88f457ed199270d85753208c" => :sierra
    sha256 "0c17ca28357c801a0fb81667ba69c1ed820d0348ca7728766ea16e3bd9b0ff19" => :el_capitan
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
