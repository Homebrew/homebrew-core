class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/swilmet/amtk"
  url "https://gitlab.gnome.org/swilmet/amtk.git",
      tag:      "5.4.1",
      revision: "3a0427b88af2680993932eae00de7cfac198bb74"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "725c9ebf6be9c39257c55b8318b527c0a299dd3479f5a0185907c226193bfbb2"
    sha256 arm64_big_sur:  "a2b4a925ae3aee8bf47903db2dc12049afea5244dfd8b26e4b73f36a3ba0c1f6"
    sha256 monterey:       "54e4004683ad940fedfeb3768b8fb36cabe0fa42fbfbda2bf58c329449ac9400"
    sha256 big_sur:        "5a202298c634cf6b8846774f2ff1f428a8ddf75e68419a1dbb9a58b13c5efc75"
    sha256 catalina:       "db85bd106fe101311e8e2b1320ba5cdcba1fd96fa9e6f435943ccbabdbcc8dba"
    sha256 x86_64_linux:   "2d09b5a1928f773a22c116e4aae53a51679d5d1fbde8e5fb831f97f27c61fdd7"
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
