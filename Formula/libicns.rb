class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "http://icns.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 2

  bottle do
    cellar :any
    sha256 "bffaa0f0f6e36f0a9cae0dc41d667126fa6236d7f65334723bc82a7e0a1b5c0b" => :sierra
    sha256 "1f1c328567040935c1c4e2f9a5602cd96b1c9a8c1ae8ee4b864a677819daceb3" => :el_capitan
    sha256 "ec50018b7b35207e8a3260d4df8cddfe518e0146c44e54cb1fa5ab80ea2fbf23" => :yosemite
  end

  option :universal

  depends_on "jasper"
  depends_on "libpng"

  def install
    # Fix for libpng 1.5
    inreplace "icnsutils/png2icns.c",
      "png_set_gray_1_2_4_to_8",
      "png_set_expand_gray_1_2_4_to_8"

    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "icns.h"
      int main(void)
      {
        int    error = 0;
        FILE            *inFile = NULL;
        icns_family_t  *iconFamily = NULL;
        icns_image_t  iconImage;
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-licns", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
