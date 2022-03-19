class Clutter < Formula
  desc "Generic high-level canvas library"
  homepage "https://wiki.gnome.org/Projects/Clutter"
  url "https://download.gnome.org/sources/clutter/1.26/clutter-1.26.4.tar.xz"
  sha256 "8b48fac159843f556d0a6be3dbfc6b083fc6d9c58a20a49a6b4919ab4263c4e6"
  license "LGPL-2.1"

  bottle do
    sha256 arm64_monterey: "462bd7556ec62d37cff950568506d5c6275bc1f36a8f5766b8a053885c06c0d3"
    sha256 arm64_big_sur:  "050dd98a11765590759dc9bfa5e289b50af4374b9deb126959c348057fc81642"
    sha256 monterey:       "e4c426ad39749772c2863e68c2e7d2891bf8d85446061a73aa473a80ebb0ade3"
    sha256 big_sur:        "b6a60fc6c91f4e0a206e75c3fe5672215eb9460304202c4bfe1a4c7402ce9bd4"
    sha256 catalina:       "ccec39ce9c941de753798e466b8cfc2a69612319d8b5a422f6e4bde49db305b1"
    sha256 mojave:         "43da6f50107059a3c9b215e77d29724f9e71a17fd89f5e72a200cd021e32f471"
    sha256 high_sierra:    "2a1f93e956dbfc9dc4f3c47dd8923b224ed155f3b8dbf32df74f365a65052bbb"
    sha256 x86_64_linux:   "90f6ab166d1dba5dc5bfb9760dfc54ae8d20ac16948ea76783aedb16499487e5"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
    ]

    if OS.mac?
      args += %w[
        --without-x
        --enable-x11-backend=no
        --enable-quartz-backend=yes
      ]
    end

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
    harfbuzz = Formula["harfbuzz"]
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
      -I#{harfbuzz.opt_include}/harfbuzz
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
      -ljson-glib-1.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
