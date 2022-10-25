class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/World/amtk"
  url "https://gitlab.gnome.org/World/amtk.git",
      tag:      "5.5.2",
      revision: "3d285cf36ba6caf3db8b2a867144ad13b9961769"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "eab89d566df2c2b57fe499770ddd2ad107b9e411e3147bd720a8c6dcfcd81481"
    sha256 arm64_big_sur:  "0ecbe4c316e78de17363c4342204f3b6460894b0d97302ac5112479e05e70ca3"
    sha256 monterey:       "6f8c1771624d8f03f010575e70f42e15c7f92ae50f4c2a70a037f6945b61c48a"
    sha256 big_sur:        "e5ecc2d8860499179398fdebd9100f09f481cdba8dfb2fce842d6efca8897842"
    sha256 catalina:       "9430132d711c0d8c1a677b9554710487497949e56f845b395ad4a3a314b8fc40"
    sha256 x86_64_linux:   "60236dc4b452bb5151db5b0da92842b4b59d26e74a0e862c63cb9b25872aa675"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    cd "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
    if OS.mac?
      flags << "-lintl"
      flags << "-lamtk-5.0"
    else
      flags << "-lamtk-5"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
