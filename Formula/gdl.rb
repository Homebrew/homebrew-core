class Gdl < Formula
  desc "GNOME Docking Library provides docking features for GTK+ 3"
  homepage "https://gitlab.gnome.org/GNOME/gdl"
  url "https://download.gnome.org/sources/gdl/3.40/gdl-3.40.0.tar.xz"
  sha256 "3641d4fd669d1e1818aeff3cf9ffb7887fc5c367850b78c28c775eba4ab6a555"
  license "LGPL-2.0-or-later"

  bottle do
    sha256                               arm64_big_sur: "ef295dc3cfd05bf245b94552e008acc047e03e2806e93374879e7881b5c94871"
    sha256                               big_sur:       "30164281abee8e2047138cddc735d9a9e1ec520f673d468a601b6cfbc988cdd3"
    sha256                               catalina:      "5acba250d8c77d17be5ff312bf11d6aa33cb609c4c351b2a1cd1bf565e73e81a"
    sha256                               mojave:        "2e2e04543eaf7ee02a791433fbab570d3b5f44651cec8dd56a40a519c2a38d24"
    sha256                               high_sierra:   "abd9360935baecd914847697e5a21e7b7d91b94c0d5878509921cdb2ba72799c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c6f276a6341d271f31979ee5f8b88216d08c2b51495187f621be0fe8d151a9"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libxml2"

  def install
    on_linux do
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gdl/gdl.h>

      int main(int argc, char *argv[]) {
        GType type = gdl_dock_object_get_type();
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
      -I#{include}/libgdl-3.0
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
      -lgdl-3
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
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
