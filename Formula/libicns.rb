class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "https://icns.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 3

  bottle do
    cellar :any
    sha256 "33e4b9bf7de81d160ba9f8802c24e89c90903e6be9a3103c7e296536b1fe1511" => :catalina
    sha256 "fe7c57605e6f9b5626f5c2048aacd121c2c8973d24113f03275ed0659392a9fb" => :mojave
    sha256 "a2c03e94df9a8291b73c544d188d9e796161f49e0f14b8c88f94da40d3cfa04f" => :high_sierra
    sha256 "8fb5848fa2a111b3fc66aaea73c60a0795da6468e2ace92d2de57c9c8a5a3cde" => :sierra
    sha256 "12579e9f34ef57d3979b5a01206b543a67bf313cdb056d6c3e20e0b8cf0842b6" => :el_capitan
    sha256 "aed1a7df05a8f98ea64dcdd8c4a406207239b7b187629fc03ae799308a142a4d" => :yosemite
  end

  depends_on "jasper"
  depends_on "libpng"

  def install
    # Fix for libpng 1.5
    inreplace "icnsutils/png2icns.c",
      "png_set_gray_1_2_4_to_8",
      "png_set_expand_gray_1_2_4_to_8"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
