class LibpngAT12 < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng12/libpng-1.2.54.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/libpng-1.2.54.tar.xz"
  sha256 "cf85516482780f2bc2c5b5073902f12b1519019d47bf473326c2018bdff1d272"

  bottle do
    cellar :any
    sha256 "0f85343171350540afdbea7912b1c3873be2674c20939cb9586f549df0b0ac7b" => :sierra
    sha256 "3a77919fd1e4776d87df3838dfffb1e6588cd71798424cf809ccebd284bc2f08" => :el_capitan
    sha256 "65c40b981d5fb639087ebabca450d1a70596049bc45dbfbbec3e7e93a31454c4" => :yosemite
  end

  keg_only :versioned_formula

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
