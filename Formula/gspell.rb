class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.12/gspell-1.12.0.tar.xz"
  sha256 "40d2850f1bb6e8775246fa1e39438b36caafbdbada1d28a19fa1ca07e1ff82ad"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "051151cc7d8ff3f5979400110bc060e54463c25eaa6c90eb96409ebdeb46876a"
    sha256 arm64_big_sur:  "ea202d1b22a46328a1ce6e9a4b4cc5df4c2fe543f9c96bbb7c37cbe3b19768c6"
    sha256 monterey:       "9dc9c7d1afd7ce981156ef1a1bbcd96d65f3dad37f5f487ac5e2c66a2d0c7502"
    sha256 big_sur:        "708870895dddebafc6a52e320d7d74daa9dbddf7f845f6b9dea715ac50fde5b2"
    sha256 catalina:       "213afc54fb35d2772ac32af7240810638898be599797bd82a9b0006686df1aa7"
    sha256 x86_64_linux:   "03545e9ae95df912a035c631750bc50256961319e19bfb3397ed090bf4ce8207"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "enchant"
  depends_on "gtk+3"
  depends_on "iso-codes"
  depends_on "vala"

  uses_from_macos "libffi"

  on_macos do
    depends_on "gtk-mac-integration"
  end

  patch :DATA

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
    ]
    if OS.mac?
      gtk_mac_integration = Formula["gtk-mac-integration"]
      flags << "-I#{gtk_mac_integration.opt_include}/gtkmacintegration"
    end
    flags += %W[
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
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
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
+	$(GTK_MAC_LIBS) \
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
