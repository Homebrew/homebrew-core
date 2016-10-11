class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.25.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.6.25.tar.xz"
  sha256 "09fe8d8341e8bfcfb3263100d9ac7ea2155b28dd8535f179111c1672ac8d8811"

  bottle do
    cellar :any
    sha256 "dcec3ac5099600c6b52aae0ba294c26ffce38b21031d489a7ae29c4b6c26daf2" => :sierra
    sha256 "5583f8fb37ea934656ddc4cb1d315ca02df147f43ba371ed9c7bca18c645df63" => :el_capitan
    sha256 "cdd558a23bda106af96a709affe536491281d6386b05b88747838ae238d9341b" => :yosemite
    sha256 "9da2cc58613f146446cca39f8dca1a72cb0adcabc787496fa4386e2dfde40ea8" => :mavericks
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
