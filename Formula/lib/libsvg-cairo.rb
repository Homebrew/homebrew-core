class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  license "LGPL-2.1"
  revision 3

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg-cairo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "528ec2ea8ffedaff6d5eac18dbb22a8edfc0f41eb8b8fa7bf85068c3bcabb745"
    sha256 cellar: :any,                 arm64_monterey: "039c1d99e08efc5f9b5df9a30ce5d0ff4acde9c3f4f3890b4fb8cd287d12adc1"
    sha256 cellar: :any,                 arm64_big_sur:  "fe8c78e4969c745b6808cd2f4c8f2d084a1f30687edd98074a1d43dd925fabbc"
    sha256 cellar: :any,                 ventura:        "406b34bdef48019bb54867008b08e966b11b7209c77f5a3b2e384771ea20b5dc"
    sha256 cellar: :any,                 monterey:       "2d381b736e28fc35193fd120bd265f6cc73e3805d945982db709f2a517015cd2"
    sha256 cellar: :any,                 big_sur:        "a2d1eeb52e59366b77b50d16ec49aa0dc65d03315bde893248d982dca7d8b06f"
    sha256 cellar: :any,                 catalina:       "d7e3121dc97fdd10cc498e78c60721777a9c17d686d07de769c157d1bf9ed7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7459ca5ab6d29337f341de7af38ce53bbc007974bfd57e5be4d9b4ad66ba69a"
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
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
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
