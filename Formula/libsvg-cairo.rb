class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  license "LGPL-2.1"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg-cairo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "183ec744f0fb9063a1d1e83518192d460af2486aa53ae7259311205bc43764f3"
    sha256 cellar: :any,                 arm64_big_sur:  "5d4898e15f1a78df7856483ff233fbb38fcd4400c5842742968ed3e999be7171"
    sha256 cellar: :any,                 monterey:       "a6f189e43606af321b7b83749d538e61b8ff09d6c6970acf01e26796cb448f53"
    sha256 cellar: :any,                 big_sur:        "d2d48b901a9ac8ad056adab1f6483d6ad17afcfeac95362ca7b32d473de84d69"
    sha256 cellar: :any,                 catalina:       "91b325120c82295bea226193e0c0e0a26ffc7a4e6dc07c41bc474676c3aa302c"
    sha256 cellar: :any,                 mojave:         "573c68cc663ad978709b2f82072070e9d12be173665ef057d61c569bae428ad7"
    sha256 cellar: :any,                 high_sierra:    "85692fcfce287f166fefa4fcc4f78b58c96eee3c94ff403e6ef42403c005c29a"
    sha256 cellar: :any,                 sierra:         "63cfba79036bfd190a92e6a4c501e2e4c737bf63e6a8df6bdca56885c66ae740"
    sha256 cellar: :any,                 el_capitan:     "9f87cc3a6d7e702aab12b23ad1f720ae592bdfb9112753e27c9cf2203dc21915"
    sha256 cellar: :any,                 yosemite:       "55bd8f9bfede25e71e9731d72ace27ce7724a4cce030a4e4e6969554ee64238d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84bfe0e1e29eaf849377cc745c670b22ab85c34386d57b541d9dae456942125e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsvg"

  # libsvg: fix for ARM/M1 Macs
  # Patch to update to newer autotools
  # (https://cgit.freedesktop.org/cairo/commit/?id=afdf3917ee86a7d8ae17f556db96478682674a76)
  patch :DATA

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg xmlns:svg="http://www.w3.org/2000/svg" height="72pt" width="144pt" viewBox="0 -20 144 72"><text font-size="12" text-anchor="left" y="0" x="0" font-family="Times New Roman" fill="green">sample text here</text></svg>
    EOS

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "svg-cairo.h"

      int main(int argc, char **argv) {
          svg_cairo_t *svg = NULL;
          svg_cairo_status_t result = SVG_CAIRO_STATUS_SUCCESS;
          FILE *fp = NULL;
          printf("1\\n");
          result = svg_cairo_create(&svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_create failed: %d\\n", result);
              /* Fail if alloc failed */
              return -1;
          }
          printf("2\\n");
          result = svg_cairo_parse(svg, "test.svg");
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_parse failed: %d\\n", result);
              /* Fail if alloc failed */
              return -2;
          }
          printf("3\\n");
          result = svg_cairo_destroy(svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_destroy failed: %d\\n", result);
              /* Fail if alloc failed */
              return -3;
          }
          svg = NULL;
          printf("4\\n");
          result = svg_cairo_create(&svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_create failed: %d\\n", result);
              /* Fail if alloc failed */
              return -4;
          }
          fp = fopen("test.svg", "r");
          if (NULL == fp) {
              printf ("failed to fopen test.svg\\n");
              /* Fail if alloc failed */
              return -5;
          }
          printf("5\\n");
          result = svg_cairo_parse_file(svg, fp);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_parse_file failed: %d\\n", result);
              /* Fail if alloc failed */
              return -6;
          }
          printf("6\\n");
          result = svg_cairo_destroy(svg);
          if (SVG_CAIRO_STATUS_SUCCESS != result) {
              printf ("svg_cairo_destroy failed: %d\\n", result);
              /* Fail if alloc failed */
              return -7;
          }
          svg = NULL;
          printf("SUCCESS\\n");
          return 0;
      }
    EOS

    cairo = Formula["cairo"]
    system ENV.cc, "test.c", "-I#{include}", "-I#{cairo.opt_include}/cairo", "-L#{lib}", "-lsvg-cairo", "-o", "test"
    assert_equal "1\n2\n3\n4\n5\n6\nSUCCESS\n", shell_output("./test")
  end
end

__END__
diff --git a/configure.in b/configure.in
index 3407e0d..627bbc5 100755
--- a/configure.in
+++ b/configure.in
@@ -8,18 +8,18 @@ LIBSVG_CAIRO_VERSION=0.1.6
 # libtool shared library version

 # Increment if the interface has additions, changes, removals.
-LT_CURRENT=1
+m4_define(LT_CURRENT, 1)

 # Increment any time the source changes; set to
 # 0 if you increment CURRENT
-LT_REVISION=1
+m4_define(LT_REVISION, 1)

 # Increment if any interfaces have been added; set to 0
 # if any interfaces have been removed. removal has
 # precedence over adding, so set to 0 if both happened.
-LT_AGE=0
+m4_define(LT_AGE, 0)

-VERSION_INFO="$LT_CURRENT:$LT_REVISION:$LT_AGE"
+VERSION_INFO="LT_CURRENT():LT_REVISION():LT_AGE()"
 AC_SUBST(VERSION_INFO)

 dnl ===========================================================================
