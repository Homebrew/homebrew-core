class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.36.tar.xz"
  sha256 "27a6ef157743350c807ffea59baa1d70226dbede82a5e953ffd58ea6059fe691"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9b2efc06a7642c64077d80b6e3411e8d51ab3233895b19e502d3ce4d73cba1a6"
    sha256 arm64_monterey: "ab94913ae9bf73f5457a71b5d57c230d7a8ce9d0a99e473e70aa17ec327f610f"
    sha256 arm64_big_sur:  "234803d64c7f59029cd6a31050a774de5a5af82629113c773568770f61da24af"
    sha256 ventura:        "41a3abf3a909d9bb3b4b292f1826e163604de3dada6166aba38735bba0b18a90"
    sha256 monterey:       "69de0c3dae59346f049d267b7ec2c2c0f47dcc659a72f28128d6eebae8b4481e"
    sha256 big_sur:        "9d7b366b498ed385cf8b1850b3d73d86c83cb58c2065b782c915eefbbac0f25d"
    sha256 catalina:       "3e7aebc47f8a600f25a63b9ccaec72ab9fb4fecfa9c97e48c018b32e114e0e2b"
    sha256 x86_64_linux:   "d6208fd58f89bc1d5fa82b05d213f0ee8dc867d55563c54fa46228c76973090e"
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

  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "cmake" => :build
    depends_on "at-spi2-atk"
    depends_on "cairo"
    depends_on "iso-codes"
    depends_on "libxkbcommon"
    depends_on "wayland-protocols"
    depends_on "xorgproto"

    # fix ERROR: Non-existent build file 'gdk/wayland/cursor/meson.build'
    # upstream commit reference, https://gitlab.gnome.org/GNOME/gtk/-/commit/66a19980
    # remove in next release
    patch :DATA
  end

  def install
    args = std_meson_args + %w[
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    if OS.mac?
      args << "-Dquartz_backend=true"
      args << "-Dx11_backend=false"
    end

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
    system "#{bin}/gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
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
    harfbuzz = Formula["harfbuzz"]
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
      -I#{harfbuzz.opt_include}/harfbuzz
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
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk+-3.0.pc").strip
  end
end

__END__
diff --git a/gdk/wayland/cursor/meson.build b/gdk/wayland/cursor/meson.build
new file mode 100644
index 0000000000000000000000000000000000000000..02d5f2bed8d926ee26bcf4c4081d18fc9d53fd5b
--- /dev/null
+++ b/gdk/wayland/cursor/meson.build
@@ -0,0 +1,12 @@
+wayland_cursor_sources = files([
+  'wayland-cursor.c',
+  'xcursor.c',
+  'os-compatibility.c'
+])
+
+libwayland_cursor = static_library('wayland+cursor',
+  sources: wayland_cursor_sources,
+  include_directories: [ confinc, ],
+  dependencies: [ glib_dep, wlclientdep, ],
+  c_args: common_cflags,
+)
