class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.22/gtk+-3.22.28.tar.xz"
  sha256 "d299612b018cfed7b2c689168ab52b668023708e17c335eb592260d186f15e1f"

  bottle do
    sha256 "58867309a23a6bf9d2d73e1fdb16393b7f6670260a5e4318ac66ee603bc85a32" => :high_sierra
    sha256 "9138b9852ee2d1a465d1c90981fd889f53dc6b6ee8f1edda1322b6b9ccdb83dd" => :sierra
    sha256 "6833044f8a039c85eb220143bc1a1953ddcc36c2c4648ca91d991b36c7b454b3" => :el_capitan
  end

  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "pango"
  depends_on "glib"
  depends_on "hicolor-icon-theme"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "jasper" => :optional

  # patch taken from https://gitlab.gnome.org/GNOME/gtk/issues/32
  # should be removed in next update
  patch :DATA

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

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

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
diff --git a/gdk/quartz/gdkquartz.h b/gdk/quartz/gdkquartz.h
index be2cb3c..24555d4 100644
--- a/gdk/quartz/gdkquartz.h
+++ b/gdk/quartz/gdkquartz.h
@@ -60,8 +60,11 @@ typedef enum
 GDK_AVAILABLE_IN_ALL
 GdkOSXVersion gdk_quartz_osx_version (void);

+GDK_AVAILABLE_IN_ALL
 GdkAtom   gdk_quartz_pasteboard_type_to_atom_libgtk_only        (NSString       *type);
+GDK_AVAILABLE_IN_ALL
 NSString *gdk_quartz_target_to_pasteboard_type_libgtk_only      (const gchar    *target);
+GDK_AVAILABLE_IN_ALL
 NSString *gdk_quartz_atom_to_pasteboard_type_libgtk_only        (GdkAtom         atom);

 G_END_DECLS

