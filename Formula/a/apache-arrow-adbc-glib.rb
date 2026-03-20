class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-22/apache-arrow-adbc-22.tar.gz"
  sha256 "48b19d70a734e789da99e3c53ebad57389c914b85fdc9c509188e5f50896b07c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow-adbc"
  depends_on "apache-arrow-glib"
  depends_on "glib"

  # Backport fix for Apache Arrow GLib 23.0.0+ support
  # https://github.com/apache/arrow-adbc/commit/1a73104a338b73ae8705e4816cfdc48af1fd2ebf
  # Can be removed when bumping this formula to version 23
  patch :DATA

  def install
    system "meson", "setup", "build", "glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <adbc-glib/adbc-glib.h>
      int main(void) {
        GError *error = NULL;
        GADBCDatabase *database = gadbc_database_new(&error);
        if (database) {
          g_object_unref(database);
        }
        return error ? 1 : 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs adbc-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/glib/adbc-arrow-glib/meson.build b/glib/adbc-arrow-glib/meson.build
index 732e27033..dfbfd6bf0 100644
--- a/glib/adbc-arrow-glib/meson.build
+++ b/glib/adbc-arrow-glib/meson.build
@@ -82,6 +82,14 @@ pkgconfig.generate(
     version: meson.project_version(),
 )

+if arrow_glib.version().version_compare('>=23.0.0')
+    components = arrow_glib.version().split('.')
+    major = components[0]
+    minor = components[1]
+    arrow_glib_gir_api_version = f'@major@.@minor@'
+else
+    arrow_glib_gir_api_version = '1.0'
+endif
 adbc_arrow_glib_gir = \
     gnome.generate_gir(
     libadbc_arrow_glib,
@@ -91,7 +99,7 @@ adbc_arrow_glib_gir = \
     fatal_warnings: gi_fatal_warnings,
     header: 'adbc-arrow-glib/adbc-arrow-glib.h',
     identifier_prefix: 'GADBCArrow',
-    includes: ['ADBC-1.0', 'Arrow-1.0'],
+    includes: ['ADBC-1.0', f'Arrow-@arrow_glib_gir_api_version@'],
     install: true,
     namespace: 'ADBCArrow',
     nsversion: api_version,
