class Clutter < Formula
  desc "Generic high-level canvas library"
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "https://download.gnome.org/sources/clutter/1.26/clutter-1.26.2.tar.xz"
  sha256 "e7233314983055e9018f94f56882e29e7fc34d8d35de030789fdcd9b2d0e2e56"
  revision 1

  bottle do
    sha256 "87e40791a3825261a8b37eb2e159f0b32bbd9be6aacb3bb288df0b39b1c4d1b1" => :mojave
    sha256 "cd1bad834964168854f060603548fb495a629cbf98a119050cb1ff2a4ef41b67" => :high_sierra
    sha256 "feebbe98a8c3cc1ad25202719451b4e9db64c145583ea1bd3b0d540e23cc8bf6" => :sierra
    sha256 "fe6f945a3aac285dd0f21d1bdf0e4da08ac179c7cde03198af98c69166ccce6e" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo" # for cairo-gobject
  depends_on "cogl"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "json-glib"
  depends_on "pango"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --enable-introspection=yes
      --disable-silent-rules
      --disable-Bsymbolic
      --disable-examples
      --disable-gtk-doc-html
      --enable-gdk-pixbuf=yes
      --without-x --enable-x11-backend=no
      --enable-quartz-backend=yes
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <clutter/clutter.h>

      int main(int argc, char *argv[]) {
        GOptionGroup *group = clutter_get_option_group_without_init();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    cogl = Formula["cogl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{cogl.opt_include}/cogl
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/clutter-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cogl.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lclutter-1.0
      -lcogl
      -lcogl-pango
      -lcogl-path
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
