class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/libpng/libpng-1.6.36.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.36/libpng-1.6.36.tar.xz"
  sha256 "eceb924c1fa6b79172fdfd008d335f0e59172a86a66481e09d4089df872aa319"

  bottle do
    cellar :any
    sha256 "7f6ac019c4413445dfa4d5ccbecfde564bf50b66ea32668bc360ad6edc78707d" => :mojave
    sha256 "b79c005157a135c42d42fbd7bf2f13537964a24225cc2bae51dd97908799fe08" => :high_sierra
    sha256 "b501cf867a3cb3adabf72b0da6c165ee3e803c39301c92b67ec449a914551238" => :sierra
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
