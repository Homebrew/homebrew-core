class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.0/gtk-4.0.0.tar.xz"
  sha256 "d46cf5b127ea27dd9e5d2ff6ed500cb4067eeb2cb1cd2c313ccde8013b0b9bf9"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  # submitted upstream at https://gitlab.gnome.org/GNOME/gtk/-/merge_requests/2962
  patch :DATA

  def install
    args = std_meson_args + %w[
      -Dx11-backend=false
      -Dmacos-backend=true
      -Dgtk_doc=false
      -Dman-pages=true
      -Dintrospection=enabled
      -Dbuild-examples=false
      -Dbuild-tests=false
    ]

    args << "-Dprint-cups=disabled" if MacOS.version <= :mojave

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules #{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end

__END__
diff --git a/gdk/macos/gdkmacostoplevelsurface.c b/gdk/macos/gdkmacostoplevelsurface.c
index e1f60e8221..4a84dc8304 100644
--- a/gdk/macos/gdkmacostoplevelsurface.c
+++ b/gdk/macos/gdkmacostoplevelsurface.c
@@ -97,7 +97,7 @@ _gdk_macos_toplevel_surface_present (GdkToplevel       *toplevel,
   GdkSurfaceHints mask;
   NSWindowStyleMask style_mask;
   gboolean maximize;
-  gboolean fullscreen
+  gboolean fullscreen;

   g_assert (GDK_IS_MACOS_TOPLEVEL_SURFACE (self));
   g_assert (GDK_IS_MACOS_WINDOW (nswindow));

