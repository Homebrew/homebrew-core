class Gtksourceview3 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/3.24/gtksourceview-3.24.11.tar.xz"
  sha256 "691b074a37b2a307f7f48edc5b8c7afa7301709be56378ccf9cc9735909077fd"
  license "LGPL-2.1-or-later"
  revision 3

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "920ee02f85863c74d7c151cde00f0a8dbd18c66e825a50c7d8f36f3af9da06b6"
    sha256 big_sur:       "2dc6c71c803b006967ee4154912c7f6e050c5c8c8f68a113335e66f48fe32277"
    sha256 catalina:      "e82371b46c1d8206c5aedf9966835e27ffb3bd011ad936bffa0e26cfe3c2808c"
    sha256 mojave:        "f9f3856ad743d604e084f77e68d2edd53d99093ce06dc23b9f0cdbdc5e70c5d0"
    sha256 high_sierra:   "d67cdf5db8996c90d56ad6468c830fcb8e28b26753ab7d332b3a4c990c17e84b"
    sha256 x86_64_linux:  "db335b9e4164c8aaf7d03badd31dad42ee3810c49427263d5883d36b213204dc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  on_macos do
    depends_on "autoconf@2.69" => :build # avoid `gtk-doc` dependency
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--verbose", "--install", "--force" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--enable-vala=yes",
                          "--enable-introspection=yes",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
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
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtksourceview-3.0
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
      -lgtksourceview-3.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
