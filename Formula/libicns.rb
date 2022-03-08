class Libicns < Formula
  desc "Library for manipulation of the macOS .icns resource format"
  homepage "https://icns.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/icns/libicns-0.8.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libi/libicns/libicns_0.8.1.orig.tar.gz"
  sha256 "335f10782fc79855cf02beac4926c4bf9f800a742445afbbf7729dab384555c2"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7f1629857173f47627750a68b5365c3b5302296077b9062022b82af8bae31d8f"
    sha256 cellar: :any,                 arm64_big_sur:  "593fecff6cdb88a92fd91a09563d3c253013128c4b00537766b905dbf988e76c"
    sha256 cellar: :any,                 monterey:       "4f58e79a5425fa0efa47388c5cb74d51f15f3f6ba5e97b32b92910004a78b933"
    sha256 cellar: :any,                 big_sur:        "460930e37a288de03e036ecdcfeb2031bf5ccd44a6abd17a9374ec006cdfa388"
    sha256 cellar: :any,                 catalina:       "b3a7a96858b1ccf7c772a4384df25b4442d021a9feb0ff3fef60d2aaf3243c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6d2b1f27b7e27161e362f4b90f4ab5783e2ad9c81525d411478c03fecfaebf"
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
