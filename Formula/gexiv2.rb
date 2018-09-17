class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.8.tar.xz"
  sha256 "81c528fd1e5e03577acd80fb77798223945f043fd1d4e06920c71202eea90801"

  bottle do
    sha256 "a44a0225ab933dd6da6dadece5ed05a7dbb83b0372795a92f0bf6466c32e4535" => :mojave
    sha256 "c6da6deffd67e16ee41a570d6b2393caa04764c077b972c8b1ab6b5bde040261" => :high_sierra
    sha256 "ef19b3b862ba328ca17665f974355737389626e72075078a55a8bb00032bb9c9" => :sierra
    sha256 "be2ec9b0a9a314e982626156bb1b262648332334e57a03bc6c45b4ef14e223a1" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "exiv2"
  depends_on "glib"
  depends_on "python@2"

  # bug report opened on 2017/12/25, closed on 2018/01/05, reopened on 2018/02/06
  # https://bugzilla.gnome.org/show_bug.cgi?id=791941
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index 8980ac9..aa0872c 100755
--- a/configure
+++ b/configure
@@ -18635,7 +18635,7 @@ case "$target_or_host" in
 esac
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: $platform_darwin" >&5
 $as_echo "$platform_darwin" >&6; }
- if test "$platform_win32" = "yes"; then
+ if test "$platform_darwin" = "yes"; then
   PLATFORM_DARWIN_TRUE=
   PLATFORM_DARWIN_FALSE='#'
 else

