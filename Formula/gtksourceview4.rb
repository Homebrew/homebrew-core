class Gtksourceview4 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/4.8/gtksourceview-4.8.4.tar.xz"
  sha256 "7ec9d18fb283d1f84a3a3eff3b7a72b09a10c9c006597b3fbabbb5958420a87d"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3903d6c034674930d5d6bf536e91114ae09f7614b24fce1c510ae4b15e94e1b3"
    sha256 arm64_monterey: "11505701bfe67d0eeeffaf5b263ebed353da572e07b149a5bfd4f0b080d6fcfd"
    sha256 arm64_big_sur:  "9499176d44c00d31e8c09cefb3e8520ae3010d6c14b058a55c91a0299edc89b3"
    sha256 ventura:        "c2bab12f7f63c4030a16612377f05f8a126d185616ff0b0467e7d086b4b94787"
    sha256 monterey:       "9c81022374dc1c1b014b4b77295b2a7bd8c7c481997a9fa2d8f70f418a357de5"
    sha256 big_sur:        "6aa779236bd2122276579b2f3c16d7f4baef8b5a576f52afd0cd9f801c0b5eb4"
    sha256 catalina:       "3610af7c1030e44f504272fadddeea19dd84abbd9e0f27a3fd36b2c633b0510f"
    sha256 x86_64_linux:   "23926b28dc6ec1f7588b82cccbe70db56ca535def8b080271922358b45f291f4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  def install
    args = std_meson_args + %w[
      -Dgir=true
      -Dvapi=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
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
      -I#{include}/gtksourceview-4
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
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    if OS.mac?
      flags << "-lintl"
      flags << "-lgtksourceview-4.0"
    else
      flags << "-lgtksourceview-4"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
