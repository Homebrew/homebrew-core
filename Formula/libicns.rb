class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "https://icns.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62da03a95a4b2b2342a762839e49c70887d9a01f5e097cc7881f9287384d1e45"
    sha256 cellar: :any,                 arm64_big_sur:  "06b49357685dcaef31f7e32c7901ec217074a3b17d24c7a46456239e04ec3a9b"
    sha256 cellar: :any,                 monterey:       "7f2427496f4dc8e1f04d350b4479406ffb6c9e815a93397c0255d98593274ab1"
    sha256 cellar: :any,                 big_sur:        "6d503b029cbb646b11bae4d81c3537ea14f8c415039b196dace05a6ea691a846"
    sha256 cellar: :any,                 catalina:       "33e4b9bf7de81d160ba9f8802c24e89c90903e6be9a3103c7e296536b1fe1511"
    sha256 cellar: :any,                 mojave:         "fe7c57605e6f9b5626f5c2048aacd121c2c8973d24113f03275ed0659392a9fb"
    sha256 cellar: :any,                 high_sierra:    "a2c03e94df9a8291b73c544d188d9e796161f49e0f14b8c88f94da40d3cfa04f"
    sha256 cellar: :any,                 sierra:         "8fb5848fa2a111b3fc66aaea73c60a0795da6468e2ace92d2de57c9c8a5a3cde"
    sha256 cellar: :any,                 el_capitan:     "12579e9f34ef57d3979b5a01206b543a67bf313cdb056d6c3e20e0b8cf0842b6"
    sha256 cellar: :any,                 yosemite:       "aed1a7df05a8f98ea64dcdd8c4a406207239b7b187629fc03ae799308a142a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e62164cd0e78ae43714a373989b8543cb961ac177ae3b92ad7e2bc0e230818"
  end

  depends_on "jasper"
  depends_on "libpng"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

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
