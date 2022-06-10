class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/World/amtk"
  url "https://gitlab.gnome.org/World/amtk.git",
      tag:      "5.5.1",
      revision: "fa2835b2e60d60c924fc722a330524a378446a7d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "7b5587bb603f54bf02abbe52d81f768e7b0b634cd44e22bead4af5aecab4cfed"
    sha256 arm64_big_sur:  "27962e5fc3c82c85fdf51e4a82a75ee4a06da1a39ca5b97ea09b7ad84ba5e869"
    sha256 monterey:       "74f92cd95ff1a03c3457b148c19fa538182b969add4c854cc4f66a75eeb7d3db"
    sha256 big_sur:        "71bdd0bcb32febcf08ea78763f6ad5a2bdbbcf458fc26a93c469f9dbbb809e51"
    sha256 catalina:       "4b69fef0fe008d3fba926b6717479e2c854cbd5d5345f8ee3223336062f064a5"
    sha256 x86_64_linux:   "85ff7108192030483210131392e9ed1d2224f92f5b9a8b99e91ca6b860274be6"
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
