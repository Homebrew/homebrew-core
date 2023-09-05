class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://github.com/gedit-technology/libgedit-amtk/archive/refs/tags/5.8.0.tar.gz"
  sha256 "014d90bdc611ef855655c846a37341b8394db794b06344e07066b87c259b4f31"
  license "LGPL-3.0-or-later"
  head "https://github.com/gedit-technology/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "e6b1196ae73eaeebc6722e30a1b331841405a4414f0395fd8ec9bfddaf0258d3"
    sha256 arm64_monterey: "ce53bd6100c84e17f8d35bf92c8386369c26b396b69c4666d3b979776ad3ecb6"
    sha256 arm64_big_sur:  "b942811c4c77c9c3eae4973dfdd0bdec4340d5bcd85bcb120d4fdf1d16e8083d"
    sha256 ventura:        "5757401079d2a27249fadfd5a9e5dd6b9b382cc3c023128e296e8044506074c8"
    sha256 monterey:       "6290de91843706bc42c743422b98158fd702893a475a7e7936683dfbefaf5909"
    sha256 big_sur:        "d99e61c8a7632acd4c24af0c3ea49370d69329cad29fe5018b31669c1bf209e3"
    sha256 x86_64_linux:   "9e3a21fa3a77d3c98fb22553a21abfe163456381d2e9b8e26bdaa4f1013546da"
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
