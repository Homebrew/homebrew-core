class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/World/amtk"
  url "https://gitlab.gnome.org/World/amtk.git",
      tag:      "5.5.1",
      revision: "fa2835b2e60d60c924fc722a330524a378446a7d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "250b5e388086f70a283e63dc2287d2e9df377f05aeab3b7fd80466fe4100ecd1"
    sha256 arm64_big_sur:  "dea3d30885c8f6d1d826d5751998ed4a455402a41c59d6906b6fd9a36008a782"
    sha256 monterey:       "9c8c733791c295dbefd5c8ef7e097254823bd29dff3c0cc2b1a1caaa1c2c89d3"
    sha256 big_sur:        "325fa265fca221b9109873195f97c17be39334e8e4e997bac062f70dc190b090"
    sha256 catalina:       "9f9a3c3164918a49c3c92e6a209e51e7e966a7c96d43c981cd536b9abdc22ab1"
    sha256 x86_64_linux:   "51c6f9585fb645073a645697b971bc73eda5f23eaeaf392d0fcc0c76eaf5b101"
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
