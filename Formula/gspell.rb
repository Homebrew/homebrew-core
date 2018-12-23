class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://wiki.gnome.org/Projects/gspell"
  url "https://download.gnome.org/sources/gspell/1.8/gspell-1.8.1.tar.xz"
  sha256 "819a1d23c7603000e73f5e738bdd284342e0cd345fb0c7650999c31ec741bbe5"

  bottle do
    sha256 "073769b3815f1f8228242aa2aca8f5f0dd59f5b20e3c03e989985232b2398ef8" => :mojave
    sha256 "9b0d29afd1b3811c0c976879641f318504798b519bccc7c6eb8bcee93fd281a1" => :high_sierra
    sha256 "20df1e6769419c13b1743bec961676477fc42e1341f3d5e9cfaf4e30f372f9d6" => :sierra
    sha256 "4051d5ce5656be42be8b3d53db5282936157ca0b6320f2a782240b7f2f29d341" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "enchant"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "iso-codes"
  depends_on "vala"

  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    enchant = Formula["enchant"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtk_mac_integration = Formula["gtk-mac-integration"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{enchant.opt_include}/enchant-2
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtk_mac_integration.opt_include}/gtkmacintegration
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gspell-1
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DMAC_INTEGRATION
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
      -lgspell-1
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
diff --git a/gspell/Makefile.am b/gspell/Makefile.am
index 076a9fd..6c67184 100644
--- a/gspell/Makefile.am
+++ b/gspell/Makefile.am
@@ -91,6 +91,7 @@ nodist_libgspell_core_la_SOURCES = \
	$(BUILT_SOURCES)

 libgspell_core_la_LIBADD =	\
+	$(GTK_MAC_LIBS)		\
	$(CODE_COVERAGE_LIBS)

 libgspell_core_la_CFLAGS =	\
@@ -155,6 +156,12 @@ gspell_private_headers += \
 gspell_private_c_files += \
	gspell-osx.c

+libgspell_core_la_CFLAGS += \
+	-xobjective-c
+
+libgspell_core_la_LDFLAGS += \
+	-framework Cocoa
+
 endif # OS_OSX

 if HAVE_INTROSPECTION

