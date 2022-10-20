class Libgnomecanvas < Formula
  desc "Highlevel, structured graphics library"
  homepage "https://gitlab.gnome.org/Archive/libgnomecanvas"
  url "https://download.gnome.org/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.3.tar.bz2"
  sha256 "859b78e08489fce4d5c15c676fec1cd79782f115f516e8ad8bed6abcb8dedd40"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_monterey: "aef7d6bf446277bc167f620e3cb3da665cbd18a3b118b2234816078525b9d171"
    sha256 cellar: :any, arm64_big_sur:  "ed9d17d2b7100e9c5ef536c547119eb78e8658bc273f958e673d47383290c3d7"
    sha256 cellar: :any, monterey:       "496d5c87547b25b2f57f676fd627d58a0663737dbf993e2c11a3d535f87c03d1"
    sha256 cellar: :any, big_sur:        "e2ae279ca7759e74bf93ed0577838d7e80fef134ad5f76c671263d023bca3dd1"
    sha256 cellar: :any, catalina:       "816cd9bf11520fba1126073191c236f2355c45a137905ba978f16a506960fef0"
    sha256 cellar: :any, mojave:         "bedab86245aa4185fc9c009496ec2d0fc0d1ea53074493db08afc81bdf424a60"
  end

  deprecate! date: "2021-11-03", because: :repo_archived

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"
  depends_on "libart"
  depends_on "libglade"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--enable-glade"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgnomecanvas/libgnomecanvas.h>

      int main(int argc, char *argv[]) {
        GnomeCanvasPoints *gcp = gnome_canvas_points_new(100);
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libart = Formula["libart"]
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
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gail-1.0
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgnomecanvas-2.0
      -I#{libart.opt_include}/libart-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libart.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lart_lgpl_2
      -latk-1.0
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgnomecanvas-2
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]
    if OS.mac?
      flags << "-lgdk-quartz-2.0"
      flags << "-lgtk-quartz-2.0"
      flags << "-lintl"
    else
      flags << "-lgdk-x11-2.0"
      flags << "-lgtk-x11-2.0"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
