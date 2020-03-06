class Gedit < Formula
  desc "The GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/3.36/gedit-3.36.0.tar.xz"
  sha256 "c983dd12a4e9db7af1aaa3062e6f042811ef99a4d6382659096f2ef8fc559435"

  bottle do
    sha256 "be10a5f9c19532b6989c3c7855c450d9ce64527ea6e42b01d22928e09d4f47fa" => :catalina
    sha256 "fef39bc1e61bfd3d1bb26b66fafdece9be765e87ad9e8a83b59a60c661e69d6a" => :mojave
    sha256 "e2e0f82401cea741c126b60862a7e7066578019c06eb28f319c17361dda99c5b" => :high_sierra
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
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "tepl"

  # see https://gitlab.gnome.org/GNOME/gedit/-/merge_requests/74
  patch :DATA

  def install
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
      -I#{include}/gedit-3.36
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
      -lgedit-3.36
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
diff --git a/gedit/gedit-app-osx.m b/gedit/gedit-app-osx.m
index 07774cc53..5df1b94da 100644
--- a/gedit/gedit-app-osx.m
+++ b/gedit/gedit-app-osx.m
@@ -32,6 +32,10 @@
 #include "gedit-commands.h"
 #include "gedit-commands-private.h"
 #include "gedit-recent.h"
+#import <AppKit/AppKit.h>
+
+NSWindow *gdk_quartz_window_get_nswindow(GdkWindow *window);
+NSEvent *gdk_quartz_event_get_nsevent(GdkEvent *event);

 static GeditWindow *
 ensure_window (GeditAppOSX *app,
diff --git a/gedit/gedit-file-chooser-dialog-osx.m b/gedit/gedit-file-chooser-dialog-osx.m
index ecfbee62a..f897c81cd 100644
--- a/gedit/gedit-file-chooser-dialog-osx.m
+++ b/gedit/gedit-file-chooser-dialog-osx.m
@@ -29,6 +29,8 @@
 #include "gedit-encodings-dialog.h"
 #include "gedit-utils.h"

+NSWindow *gdk_quartz_window_get_nswindow(GdkWindow *window);
+
 struct _GeditFileChooserDialogOSX
 {
	GObject parent_instance;
