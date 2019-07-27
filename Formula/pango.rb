class Pango < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.44/pango-1.44.0.tar.xz"
  sha256 "004fffebb2ab4f89b375f4720c54b285d569526969ba791dfa20757a7f2f1d1b"

  bottle do
    sha256 "00b769ae7c76db06f9828398023c60597b11f33410b9f5b7c3f321b34fb7e0a9" => :mojave
    sha256 "6d9f9ce407e6847a262eeea81f3bd93237f0ed4648d885a97c1409d95d26d892" => :high_sierra
    sha256 "d400c90576eebb989be229742fc0fbdeb91c27e14bd98af94c05a84d2bcd7ca9" => :sierra
  end

  head do
    url "https://gitlab.gnome.org/GNOME/pango.git"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "glib"
  depends_on "harfbuzz"

  # submitted upstream as https://gitlab.gnome.org/GNOME/pango/merge_requests/105
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Ddefault_library=both",
                      "-Dintrospection=true",
                      "-Duse_fontconfig=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<~EOS
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 8c41381c..8680e56f 100644
--- a/meson.build
+++ b/meson.build
@@ -42,7 +42,8 @@ pango_conf.set('PANGO_VERSION_MICRO', pango_micro_version)
 # Maintain version scheme with libtool
 pango_soversion = 0
 pango_libversion = '@0@.@1@.@2@'.format(pango_soversion, (pango_binary_age - pango_interface_age), pango_interface_age)
-pango_osxversion = pango_binary_age + 1
+osx_current = pango_binary_age - pango_interface_age + 1
+pango_osxversion = [osx_current, '@0@.@1@.0'.format(osx_current, pango_interface_age)]

 cc = meson.get_compiler('c')
 host_system = host_machine.system()
