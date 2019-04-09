class Libdazzle < Formula
  desc "GNOME companion library to GObject and Gtk+"
  homepage "https://gitlab.gnome.org/GNOME/libdazzle"
  url "https://download.gnome.org/sources/libdazzle/3.32/libdazzle-3.32.0.tar.xz"
  sha256 "949ed80bcef8a7816a8f281e0c4389e654a1dfa1912226fe4a0d290e023b28d6"

  bottle do
    sha256 "49bc4d85d120c7e8b7e7a5d0f6ebcd5659277f69d8689ee2ee254b107d2d67f6" => :mojave
    sha256 "f9073d4d24e516af6bfba1fe36f36f2eaafd6c283fdb0b47b7bbf45adf0850bf" => :high_sierra
    sha256 "904dcdd8c24471ab8d63651f6e358023d262f172ce99447eeedfb3b490ad3f88" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gtk+3"

  # submitted upstream as https://gitlab.gnome.org/GNOME/libdazzle/merge_requests/30
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith_vapi=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <dazzle.h>

      int main(int argc, char *argv[]) {
        g_assert_false(dzl_file_manager_show(NULL, NULL));
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    graphite2 = Formula["graphite2"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{graphite2.opt_include}
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libdazzle-1.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -ldazzle-1.0
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index e468303..c0b7538 100644
--- a/meson.build
+++ b/meson.build
@@ -1,7 +1,7 @@
 project('libdazzle', 'c',
           version: '3.32.0',
           license: 'GPLv3+',
-    meson_version: '>= 0.47.2',
+    meson_version: '>= 0.48.0',
   default_options: [ 'warning_level=1', 'buildtype=debugoptimized', 'c_std=gnu11' ],
 )

@@ -26,6 +26,8 @@ current = dazzle_version_minor * 100 + dazzle_version_micro - dazzle_interface_a
 revision = dazzle_interface_age
 libversion = '@0@.@1@.@2@'.format(soversion, current, revision)

+darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, revision)]
+
 config_h = configuration_data()
 config_h.set_quoted('GETTEXT_PACKAGE', 'libdazzle')
 config_h.set_quoted('LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
diff --git a/src/meson.build b/src/meson.build
index 111b7e5..d263b86 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -100,7 +100,7 @@ endif
 libdazzle = shared_library(
   'dazzle-' + apiversion,
   libdazzle_sources,
-
+      darwin_versions: darwin_versions,
             soversion: 0,
                c_args: libdazzle_args + release_args,
          dependencies: libdazzle_deps,
