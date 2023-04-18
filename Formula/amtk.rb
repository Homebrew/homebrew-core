class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/World/amtk"
  url "https://gitlab.gnome.org/World/amtk.git",
      tag:      "5.6.1",
      revision: "f0029cf75ec416159079a27b578b9253a04b1c5a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "1cf380d9dbde9c3a165f32fe7fbfa409cfa3ace1748d07e46b22678f548450c9"
    sha256 arm64_monterey: "f2b43d8dd35fb1d0f6da7cee85a96f322135bac94a1f59c783df4498b16ff1c7"
    sha256 arm64_big_sur:  "7b773cc55530831d0b2d5ea72b5b6f061b7988f68d72db771a7787dedaa3bf11"
    sha256 ventura:        "6712f5ff43799d58d6dbbfd9f056057a3db085de298046dcef957052809b3970"
    sha256 monterey:       "5ac785fbfb332717bcd7e5999269675b55b3e4fdc227f29398c04a80d9aa85a8"
    sha256 big_sur:        "e4d747ffc31a622fb484e6f6e29ca844d31aec1add51da911a8c6750ba079f60"
    sha256 catalina:       "f057747729a7ced1beac244548ce06a22be404adf2d623ca10d3efacc3629e04"
    sha256 x86_64_linux:   "36eb21a4aff1008a95772f0f3570ce32c179b3637f508bc2525d24e7d216fd14"
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
      -lamtk-5
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
