class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.2.tar.xz"
  sha256 "5b3b05e427cc928d103561ed2e91b2b2881fe88b1f167b0b1c9990da6aac8892"
  revision 1

  bottle do
    rebuild 1
    sha256 "fb0c5cc263b43d1dedce2bc2a8fcf003e3a5cd69c0dcaf121bbef73811b549a9" => :mojave
    sha256 "37c3d322292fecab27d51ce0019a161cc6d7c3962c8ff2018e699644b62d7ac1" => :high_sierra
    sha256 "cc42cf489f495bbd09d5ba760d25697d423a8c8f0c1ac1ef866a3ab5c744bc1d" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  # see https://gitlab.gnome.org/GNOME/gtk/issues/1517
  patch :DATA

  # see https://gitlab.gnome.org/GNOME/gtk/issues/1518
  patch do
    url "https://gitlab.gnome.org/jralls/gtk/commit/efb3888af770937c6c2c184d9beea19fbc24bb4a.patch"
    sha256 "d847d1b4659153f0d815189039776054bccc73f85cfb967c5cc2cf0e0061d0d7"
  end

  # Upstream fix, remove in next version
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/commit/e105fefc4923ebd035747daa7d453243eba4a836.patch"
    sha256 "4efd9bc0c68942a8b4f3a39f683aa0d0ee5f6836012b004e9ea083894780ed91"
  end

  def install
    args = %W[
      --enable-debug=minimal
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", bin
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
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
    libepoxy = Formula["libepoxy"]
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
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gdk/quartz/gdkevents-quartz.c b/gdk/quartz/gdkevents-quartz.c
index 952d4a8189..642fe7f1ee 100644
--- a/gdk/quartz/gdkevents-quartz.c
+++ b/gdk/quartz/gdkevents-quartz.c
@@ -1551,8 +1551,10 @@ gdk_event_translate (GdkEvent *event,
           grab = _gdk_display_get_last_device_grab (_gdk_display,
                                                     gdk_seat_get_pointer (seat));
         }
-      return_val = TRUE;
     }
+
+  return_val = TRUE;
+
   switch (event_type)
     {
     case GDK_QUARTZ_LEFT_MOUSE_DOWN:
