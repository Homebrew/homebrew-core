class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b969b2900a6b58d0d9dbab2e75a4acf80710b94e4efd3834a3a83f154546e7e4"
    sha256 cellar: :any,                 arm64_big_sur:  "4b7fe8ed8d541c65566d01ce26d3d31a6f051c13d24e947000140de55fe01164"
    sha256 cellar: :any,                 monterey:       "7907ff895333961593131035febcafd23397f791b80cb0b58d33919b3291bba5"
    sha256 cellar: :any,                 big_sur:        "96c398556141fc2ad73955de0c52a0217eeeb627102099592d1ccc85250809c9"
    sha256 cellar: :any,                 catalina:       "e0f21af595963a7c99ffa098f593f5d46cf5f78facf1df84ffe97858f29fecbe"
    sha256 cellar: :any,                 mojave:         "3984d65fa6524a142ad9094aa095f106ca9c8b6857cdd3f62b913e7e3c8f5b65"
    sha256 cellar: :any,                 high_sierra:    "7cfe0b5417654beb7092afec3389a14a4c67eeaa760eb77c9b28082e40f0b11a"
    sha256 cellar: :any,                 sierra:         "c9435455e3fb30ce81d467edf1cf4c15c39fb1d061c21738007d6af2565455a7"
    sha256 cellar: :any,                 el_capitan:     "4e7903c15847c2d07a2bdf16d6ddad5a0191ef452cf7733624703fd1b5fd7859"
    sha256 cellar: :any,                 yosemite:       "05c230ab37e4f4a3b854373b5c71b275414f852d1b776a60351c0fd49c31674a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c894d2f375a55bfe838e43f76176168aafc12474d4c25f6be612de3d240ea3b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
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
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
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
                   "-L#{Formula["jpeg"].opt_lib}", "-ljpeg"
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
