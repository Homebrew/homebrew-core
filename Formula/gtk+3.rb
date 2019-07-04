class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.10.tar.xz"
  sha256 "35a8f107e2b90fda217f014c0c15cb20a6a66678f6fd7e36556d469372c01b03"

  bottle do
    sha256 "ac7f05742fa8058473e83658b88b037c3874009ffb4961410a3a31e271b61824" => :mojave
    sha256 "b42e19853420f4b32a688c556f7cc26c4a4d1658f91b81a2f0c1f44230e13490" => :high_sierra
    sha256 "e1c6700e09e739477dfc8a9d1f72d3ddb4647ace643752b1eeb1b61024adba99" => :sierra
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  # submitted upstream as https://gitlab.gnome.org/GNOME/gtk/merge_requests/983
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      -Dx11_backend=false
      -Dquartz_backend=true
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
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
diff --git a/libgail-util/meson.build b/libgail-util/meson.build
index 90fe93c..82c8aa1 100644
--- a/libgail-util/meson.build
+++ b/libgail-util/meson.build
@@ -28,4 +28,5 @@ libgailutil = shared_library('gailutil-3',
                                '-DGTK_DISABLE_DEPRECATED',
                              ] + common_cflags,
                              link_args: gailutil_link_args,
+                             darwin_versions: ['1', '1.0'],
                              install: true)
diff --git a/meson.build b/meson.build
index c6f43d5..0f818ee 100644
--- a/meson.build
+++ b/meson.build
@@ -121,7 +121,8 @@ else
   gail_library_version = '0.0.0'
 endif

-gtk_osxversions = [(100 * gtk_minor_version) + 1, '@0@.@1@.0'.format((100 * gtk_minor_version) + 1, gtk_micro_version)]
+osx_current = gtk_binary_age - gtk_interface_age + 1
+gtk_osxversions = [osx_current, '@0@.@1@.0'.format(osx_current, gtk_interface_age)]

 gtk_api_version = '@0@.0'.format(gtk_major_version)
