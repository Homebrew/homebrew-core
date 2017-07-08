class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://download.sourceforge.net/libpng/libpng-1.6.30.tar.xz"
  mirror "ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-1.6.30.tar.xz"
  sha256 "267c332ffff70cc599d3929207869f698798f1df143aa5f9597b007c14353666"

  bottle do
    cellar :any
    sha256 "d8b9466f0694deeb0844ca1740102028d097ffdd8bc2cfc953e4164e9f518bb0" => :sierra
    sha256 "c0aba9807326244cf239b75836b78f460d83659a6c9b799a90308f0b6cf4c5ae" => :el_capitan
    sha256 "51fa62d4cec2f9948b98b1fc0843a6d543c3dc2c2859c9fb8c49fe64ccfa18e9" => :yosemite
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
