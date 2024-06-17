class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://github.com/gedit-technology/libgedit-amtk/archive/refs/tags/5.8.0.tar.gz"
  sha256 "014d90bdc611ef855655c846a37341b8394db794b06344e07066b87c259b4f31"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/gedit-technology/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "a3b8cde0ae3dce7fe45f0e61ded5d303478eb035929af8991cdc791078bf4025"
    sha256 arm64_ventura:  "1a8ecc89f955d0f51f63a1d4b4cdd4513419cc9d72da6a2bf5e715e69a37f5ab"
    sha256 arm64_monterey: "baf301d49f5cf05665ab91950ceb381b6b94154750355027dc163c9568c1e6fa"
    sha256 sonoma:         "26851791308f3407ee90eee15cb9bf26477cd634778c53ab02f7069068b2e234"
    sha256 ventura:        "29c17f1c43c9428faae1759e25e9e078975f61d947e75adaff0399ee42aef4c7"
    sha256 monterey:       "ee29717adde47f1f32bc8b69230d4d8d43023062168d81da1683e67ad06106be"
    sha256 x86_64_linux:   "61d99af175776561c482cbffa60cdc2438366b67519a9e69e06144deaaae556f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
      -I#{include}/libgedit-amtk-5
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
      -lgedit-amtk-5
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
