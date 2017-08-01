class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://download.sourceforge.net/libpng/libpng-1.6.31.tar.xz"
  mirror "ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.31.tar.xz"
  sha256 "232a602de04916b2b5ce6f901829caf419519e6a16cc9cd7c1c91187d3ee8b41"

  bottle do
    cellar :any
    sha256 "8b9d3993c9e7e7e488540d1e3d87d41ade6f3902acd6a147548b4d43818af49a" => :sierra
    sha256 "93e559b7214c50b57674dd203dfc0c7030b0688e04811c478e0839d132f861e4" => :el_capitan
    sha256 "50ea09159afdd526cc27f0fbc566026a4b0abd93319628e5f0e603b95b2f8667" => :yosemite
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
