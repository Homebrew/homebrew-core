class Amtk < Formula
  desc "Actions, Menus and Toolbars Kit for GNOME"
  homepage "https://gitlab.gnome.org/World/amtk"
  url "https://gitlab.gnome.org/World/amtk.git",
      tag:      "5.6.0",
      revision: "2664f5141f097b3df0215454e1aca677a44f1cb4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "320bdafd130fdf7de1e4f11306b5d219334f278d35b0aa322ddabc19a47cd8d6"
    sha256 arm64_monterey: "402fa9fa240fefc06414425bc6bb177760cbd552975e4b6da32143c54bc0f2b7"
    sha256 arm64_big_sur:  "c57487665d414d5933e9af2bea8fab393028003c3cbea1892953ec76f6f1460e"
    sha256 ventura:        "b634e5a4b884b539b22f83c9475d98ac31b28202147dc10cf5f667aa72f7d057"
    sha256 monterey:       "86e848583341db92b092c53b61847724709caae163aa9f1a8000adcfe303b746"
    sha256 big_sur:        "b9ae220c3bb28f36bcd2d00d205cabbb418e1b63e446401e1535c9fa663cbdc8"
    sha256 catalina:       "851eb302447c5d374331f584f37c7b5849e5778a92d89832c9763adb462b8388"
    sha256 x86_64_linux:   "c8b95e01d8ebcaa256f1c9c0dc24e93fa89e7f2f6ac199148ec4c6a9ca6c6f07"
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
