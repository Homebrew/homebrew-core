class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.7.tar.xz"
  sha256 "8bbd6dce0d558ac572385d8d726c4ba5caba1da411977806ade7f0e7bf08e3b8"

  bottle do
    sha256 "54dbecf4ced2c26b385a991800d4ded8b1e088733d80c3a1788060b2a5e87093" => :high_sierra
    sha256 "966fa502c9e0dbf956dcdbc63305dbcaa92392c646754b24727f52a5891aa9ca" => :sierra
    sha256 "68c386108511133de0f88cf9a65cd2305b6935453cd6d29531e770a73e7f5c5e" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection" => :build
  depends_on "python" if MacOS.version <= :mavericks
  depends_on "glib"
  depends_on "exiv2"

  # bug report opened on 2017/12/25
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
diff --git a/Makefile.am b/Makefile.am
index 9e8610b..fbda91b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -154,7 +154,6 @@ lib@PACKAGE_NAME@_la_CPPFLAGS = $(EXIV2_CFLAGS) $(GLIB_CFLAGS)

 lib@PACKAGE_NAME@_la_LDFLAGS  = \
	$(no_undefined) -export-dynamic -version-info $(GEXIV2_VERSION_INFO) \
-	-Wl,--version-script=$(srcdir)/gexiv2/gexiv2.map \
	$(WARN_LDFLAGS)

 clean-local:
diff --git a/Makefile.in b/Makefile.in
index aeebe3b..e1455ee 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -804,7 +804,6 @@ lib@PACKAGE_NAME@_la_LIBADD = $(EXIV2_LIBS) $(GLIB_LIBS)
 lib@PACKAGE_NAME@_la_CPPFLAGS = $(EXIV2_CFLAGS) $(GLIB_CFLAGS)
 lib@PACKAGE_NAME@_la_LDFLAGS = \
	$(no_undefined) -export-dynamic -version-info $(GEXIV2_VERSION_INFO) \
-	-Wl,--version-script=$(srcdir)/gexiv2/gexiv2.map \
	$(WARN_LDFLAGS)

 TESTS_ENVIRONMENT = \
