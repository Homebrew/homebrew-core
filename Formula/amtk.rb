class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://wiki.gnome.org/Projects/Amtk"
  url "https://download.gnome.org/sources/amtk/5.2/amtk-5.2.0.tar.xz"
  sha256 "820545bb4cf87ecebc2c3638d6b6e58b8dbd60a419a9b43cf020124e5dad7078"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "63effad091e0f6f472dc0aeec62cf1623eff536542ecb91a08ea018b796a538f"
    sha256 arm64_big_sur:  "d540852fa3ee1d9af33c5c1effe96547a98c7e03d20064b508662b14c6da202f"
    sha256 monterey:       "09d224f622a97da7897d6c2bd12eeb301b99bd18f53da33ef2b816673d5095ee"
    sha256 big_sur:        "6ab887f121458fad7c480b897bb296d48daf01e3379b96098ce18ca2ae9da7b7"
    sha256 catalina:       "89e24e19e0614b13d387b9c0d2ccf89ac15f485edf49c7c39bcaa4f80deba3c1"
    sha256 mojave:         "004425110c03c91144cfd53df0f6141b05e38d86b64e96303cd6760db9e66a42"
    sha256 high_sierra:    "67ad617a78c6922647c2af49225a5f4b8fd7eff3635d0e7f8b4320687b896b60"
    sha256 x86_64_linux:   "816d3b14c924a5024ba23409a3af828a578325c0fe3eaeff9e4f81b553142ca9"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
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
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
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
      -I#{include}/amtk-5
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
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
      -lpango-1.0
      -lpangocairo-1.0
    ]
    on_macos do
      flags << "-lintl"
      flags << "-lamtk-5.0"
    end
    on_linux do
      flags << "-lamtk-5"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
