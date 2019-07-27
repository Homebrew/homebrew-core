class Gedit < Formula
  desc "The GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/3.32/gedit-3.32.0.tar.xz"
  sha256 "c9e2e2a865c962ef172892a5d3459dc834871761ae6456b68436b3b577f22ad3"

  bottle do
    sha256 "3ba61e6ff3336762087c9f14d2ad1541c5e4cc579158a1d3e53d61e16d1a2da0" => :mojave
    sha256 "a77ce65f68f102ef824bf36b0b245c0d132b0d414c7da3435e80d96625121fb5" => :high_sierra
    sha256 "ebad9cb275ba042b10b97904e9ec80a2f8c50cd365aa53814f8a7ff56cb24680" => :sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"

  # issue opened at https://gitlab.gnome.org/GNOME/gedit/issues/132
  patch :DATA

  def install
    # rename objc files
    mv "gedit/gedit-app-osx.c", "gedit/gedit-app-osx.m"
    mv "gedit/gedit-file-chooser-dialog-osx.c", "gedit/gedit-file-chooser-dialog-osx.m"

    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-qtf", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-utils.h>

      int main(int argc, char *argv[]) {
        gchar *text = gedit_utils_make_valid_utf8("test text");
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview4 = Formula["gtksourceview4"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libpeas = Formula["libpeas"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gtksourceview4.opt_include}/gtksourceview-4
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gedit-3.14
      -I#{libepoxy.opt_include}
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libpeas.opt_include}/libpeas-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{lib}/gedit
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gtksourceview4.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libpeas.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgedit-3.14
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtksourceview-4.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpeas-1.0
      -lpeas-gtk-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gedit/meson.build b/gedit/meson.build
index b920453..b6bf8a4 100644
--- a/gedit/meson.build
+++ b/gedit/meson.build
@@ -137,9 +137,20 @@ libgedit_deps = [

 if windowing_target == 'quartz'
   libgedit_sources += files(
-    'gedit-app-osx.c',
-    'gedit-file-chooser-dialog-osx.c',
+    'gedit-app-osx.m',
+    'gedit-file-chooser-dialog-osx.m',
   )
+  libgedit_c_args += [
+    '-DOS_OSX=1',
+  ]
+  libgedit_link_args += [
+    '-Wl,-framework', '-Wl,Foundation',
+    '-Wl,-framework', '-Wl,AppKit',
+  ]
+  gtk_mac_integration_dep = dependency('gtk-mac-integration-gtk3')
+  libgedit_deps += [
+    gtk_mac_integration_dep,
+  ]
 elif windowing_target == 'win32'
   libgedit_sources += files(
     'gedit-app-win32.c',
@@ -293,6 +304,12 @@ gedit_c_args = [
   '-DHAVE_CONFIG_H',
 ]

+if windowing_target == 'quartz'
+  gedit_c_args += [
+    '-DOS_OSX=1',
+  ]
+endif
+
 gedit_deps = [
   libgedit_dep,
 ]
diff --git a/meson.build b/meson.build
index 237c2ca..fe61b33 100644
--- a/meson.build
+++ b/meson.build
@@ -1,5 +1,5 @@
 project(
-  'gedit', 'c',
+  'gedit', ['c', 'objc'],
   version: '3.32.0',
   meson_version: '>=0.46.0',
   license: 'GPL2'
@@ -128,6 +128,13 @@ configure_file(
   configuration: config_h
 )

+module_suffix = []
+# Keep the autotools convention for shared module suffix because GModule
+# depends on it: https://gitlab.gnome.org/GNOME/glib/issues/520
+if ['darwin', 'ios'].contains(host_machine.system())
+  module_suffix = 'so'
+endif
+
 # Options
 build_plugins = get_option('plugins')

diff --git a/plugins/checkupdate/meson.build b/plugins/checkupdate/meson.build
index 1755357..dc55d53 100644
--- a/plugins/checkupdate/meson.build
+++ b/plugins/checkupdate/meson.build
@@ -21,7 +21,8 @@ libcheckupdate_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/docinfo/meson.build b/plugins/docinfo/meson.build
index 14a9cff..d59951d 100644
--- a/plugins/docinfo/meson.build
+++ b/plugins/docinfo/meson.build
@@ -22,7 +22,8 @@ libdocinfo_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/filebrowser/meson.build b/plugins/filebrowser/meson.build
index 374d7ed..708f7f1 100644
--- a/plugins/filebrowser/meson.build
+++ b/plugins/filebrowser/meson.build
@@ -73,7 +73,8 @@ libfilebrowser_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 # FIXME: https://github.com/mesonbuild/meson/issues/1687
diff --git a/plugins/modelines/meson.build b/plugins/modelines/meson.build
index 3801150..598dfe1 100644
--- a/plugins/modelines/meson.build
+++ b/plugins/modelines/meson.build
@@ -21,7 +21,8 @@ libmodelines_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/quickhighlight/meson.build b/plugins/quickhighlight/meson.build
index 2be303c..0580a63 100644
--- a/plugins/quickhighlight/meson.build
+++ b/plugins/quickhighlight/meson.build
@@ -20,7 +20,8 @@ libquickhighlight_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/sort/meson.build b/plugins/sort/meson.build
index 64063ac..187dfc0 100644
--- a/plugins/sort/meson.build
+++ b/plugins/sort/meson.build
@@ -22,7 +22,8 @@ libsort_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/spell/meson.build b/plugins/spell/meson.build
index f9c4f6c..7310348 100644
--- a/plugins/spell/meson.build
+++ b/plugins/spell/meson.build
@@ -22,7 +22,8 @@ libspell_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 custom_target(
diff --git a/plugins/time/meson.build b/plugins/time/meson.build
index 36fdeb6..4294abc 100644
--- a/plugins/time/meson.build
+++ b/plugins/time/meson.build
@@ -38,7 +38,8 @@ libtime_sha = shared_module(
   install_dir: join_paths(
     pkglibdir,
     'plugins',
-  )
+  ),
+  name_suffix: module_suffix,
 )

 configure_file(
