class Gtkextra < Formula
  desc "Widgets for creating GUIs for GTK+"
  homepage "https://gtkextra.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gtkextra/3.3/gtkextra-3.3.4.tar.gz"
  sha256 "651b738a78edbd5d6ccb64f5a256c39ec35fbbed898e54a3ab7e6cf8fd82f1d6"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8fdb88a373d7427090b1fecf13971afe93314c4b6fec59dea719c5e97f25786c"
    sha256 cellar: :any,                 arm64_big_sur:  "841d46dfdaee00be8a853e8069db2b8ca1fbbfcaf298360411b6f9c0a0706da6"
    sha256 cellar: :any,                 monterey:       "edc44c31e40d7a41a5b9d9f5074732f39896ba827f61e608c4c86c50c20fe841"
    sha256 cellar: :any,                 big_sur:        "3c35df2372587b0cc5bde265a9ff06774ec70651ac5aa103639dc41e669ae3b7"
    sha256 cellar: :any,                 catalina:       "17ba389425eea1e26e308f07b94a3f8637645e83a7b8314681f2285e09996d9b"
    sha256 cellar: :any,                 mojave:         "d154740567dfe6c084d3ba87d2afb32e9be63b370f85828e01cd5a3ec164d18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ff3052d9c03812e4c97cf79786a4395b9cf431588fc7f771331d049bbe6127"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-tests",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkextra/gtkextra.h>
      int main(int argc, char *argv[]) {
        GtkWidget *canvas = gtk_plot_canvas_new(GTK_PLOT_A4_H, GTK_PLOT_A4_W, 0.8);
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
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]

    backend = "quartz"
    on_linux do
      backend = "x11"
    end

    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtkextra-3.0
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
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-#{backend}-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-#{backend}-2.0
      -lgtkextra-#{backend}-3.0
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
