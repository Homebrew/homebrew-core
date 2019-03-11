class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/3.32/libgweather-3.32.0.tar.xz"
  sha256 "de9a2b392a8b27e012ed80bb9c950085692cd8e898c367c092df15f964a91d13"

  bottle do
    sha256 "137f07c2a0bdf653569594a0146ed8abd6753dfb03aa30b5ee90bc021e0d8385" => :mojave
    sha256 "e3b603ae019c321c67ecc90e49888c0d1587a4846ccb0c7a558b2b42d3f678cc" => :high_sierra
    sha256 "2dd576463b258ad2c9a40abd6dae3ab8100e0a4794b2827e65a2fbcc7d78b48a" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "geocode-glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  # patch submitted upstream at https://gitlab.gnome.org/GNOME/libgweather/merge_requests/23
  patch :DATA

  def install
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end

    # to be removed when https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222 is fixed
    inreplace share/"gir-1.0/GWeather-3.0.gir", "@rpath", lib.to_s
    system "g-ir-compiler", "--output=#{lib}/girepository-1.0/GWeather-3.0.typelib", share/"gir-1.0/GWeather-3.0.gir"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgweather/gweather.h>

      int main(int argc, char *argv[]) {
        GType type = gweather_info_get_type();
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
    gtkx3 = Formula["gtk+3"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    libsoup = Formula["libsoup"]
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
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{include}/libgweather-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pango.opt_include}/pango-1.0
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
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgweather-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE=1", "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/libgweather/meson.build b/libgweather/meson.build
index 301e7e8..6688807 100644
--- a/libgweather/meson.build
+++ b/libgweather/meson.build
@@ -62,6 +62,7 @@ lib_libgweather = shared_library('gweather-3',
   include_directories: root_inc,
   dependencies: deps_libgweather,
   version: libgweather_so_version,
+  darwin_versions: libgweather_darwin_versions,
   install: true,
 )

diff --git a/meson.build b/meson.build
index eb27da4..862d705 100644
--- a/meson.build
+++ b/meson.build
@@ -21,6 +21,10 @@ libgweather_lt_a=0
 libgweather_so_version = '@0@.@1@.@2@'.format((libgweather_lt_c - libgweather_lt_a),
                                             libgweather_lt_a, libgweather_lt_r)

+current = libgweather_lt_c - libgweather_lt_a
+interface_age = libgweather_lt_r
+libgweather_darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, interface_age)]
+
 pkgconfig = import('pkgconfig')
 gnome = import('gnome')
 i18n = import('i18n')
