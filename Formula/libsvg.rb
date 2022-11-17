class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "331a886e259749749bbaeed305a1727a8c4ecea79e1eca5949be34d87f0abfa0"
    sha256 cellar: :any,                 arm64_monterey: "9b82d4f937112bd04869cb7089cf8af73a5bcaf9273c0078be79c2bd5aac6510"
    sha256 cellar: :any,                 arm64_big_sur:  "c77d338da584cd0b58841e34be440b16ac012994888d1b4ad0938c1ea0d28dde"
    sha256 cellar: :any,                 ventura:        "ba25653dfad1cd950f306b008f475a1a270f86615cae4ccdf86299596e5361fd"
    sha256 cellar: :any,                 monterey:       "4240c3c651800b8f8a25ab51dfa6ed069903e22b5495803633e918a345a74479"
    sha256 cellar: :any,                 big_sur:        "8ec002009c6156b77c475d1841ea2c98224afce021dfb629cdd2dda3cb18d37e"
    sha256 cellar: :any,                 catalina:       "a46a3e610e875c4d3de003a0399a73272970cd89617aacc8eb0fa1257b967208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e8c036d685732349dde481452b4cf7c7f478ee075016dffdd66d49e2dc4010a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "libxml2"

  # Fix undefined reference to 'png_set_gray_1_2_4_to_8' in libpng 1.4.0+
  patch do
    url "https://raw.githubusercontent.com/buildroot/buildroot/45c3b0ec49fac67cc81651f0bed063722a48dc29/package/libsvg/0002-Fix-undefined-symbol-png_set_gray_1_2_4_to_8.patch"
    sha256 "a0ca1e25ea6bd5cb9aac57ac541c90ebe3b12c1340dbc5762d487d827064e0b9"
  end

  # Allow building on M1 Macs. This patch is adapted from
  # https://cgit.freedesktop.org/cairo/commit/?id=afdf3917ee86a7d8ae17f556db96478682674a76
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
      #include "svg.h"

      int main(int argc, char **argv) {
          svg_t *svg = NULL;
          svg_status_t result = SVG_STATUS_SUCCESS;
          FILE *fp = NULL;

          printf("1\\n");
          result = svg_create(&svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_create failed\\n");
              /* Fail if alloc failed */
              return -1;
          }

          printf("2\\n");
          result = svg_parse(svg, "test.svg");
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_parse failed\\n");
              /* Fail if alloc failed */
              return -2;
          }

          printf("3\\n");
          result = svg_destroy(svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_destroy failed\\n");
              /* Fail if alloc failed */
              return -3;
          }
          svg = NULL;

          printf("4\\n");
          result = svg_create(&svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_create failed\\n");
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
          result = svg_parse_file(svg, fp);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_parse_file failed\\n");
              /* Fail if alloc failed */
              return -6;
          }

          printf("6\\n");
          result = svg_destroy(svg);
          if (SVG_STATUS_SUCCESS != result) {
              printf ("svg_destroy failed\\n");
              /* Fail if alloc failed */
              return -7;
          }
          svg = NULL;
          printf("SUCCESS\\n");

          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsvg",
                   "-L#{Formula["libpng"].opt_lib}", "-lpng",
                   "-L#{Formula["jpeg-turbo"].opt_lib}", "-ljpeg",
                   "-Wl,-rpath,#{Formula["jpeg-turbo"].opt_lib}",
                   "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    assert_equal "1\n2\n3\n4\n5\n6\nSUCCESS\n", shell_output("./test")
  end
end

__END__
diff --git a/configure.in b/configure.in
index a9f871e..c84d417 100755
--- a/configure.in
+++ b/configure.in
@@ -8,18 +8,18 @@ LIBSVG_VERSION=0.1.4
 # libtool shared library version
 
 # Increment if the interface has additions, changes, removals.
-LT_CURRENT=1
+m4_define(LT_CURRENT, 1)
 
 # Increment any time the source changes; set to
 # 0 if you increment CURRENT
-LT_REVISION=0
+m4_define(LT_REVISION, 0)
 
 # Increment if any interfaces have been added; set to 0
 # if any interfaces have been removed. removal has
 # precedence over adding, so set to 0 if both happened.
-LT_AGE=0
+m4_define(LT_AGE, 0)
 
-VERSION_INFO="$LT_CURRENT:$LT_REVISION:$LT_AGE"
+VERSION_INFO="LT_CURRENT():LT_REVISION():LT_AGE()"
 AC_SUBST(VERSION_INFO)
 
 dnl ===========================================================================
