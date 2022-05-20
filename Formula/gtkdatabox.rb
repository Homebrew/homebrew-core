class Gtkdatabox < Formula
  desc "Widget for live display of large amounts of changing data"
  homepage "https://sourceforge.net/projects/gtkdatabox/"
  url "https://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox-1/gtkdatabox-1.0.0.tar.gz"
  sha256 "8bee70206494a422ecfec9a88d32d914c50bb7a0c0e8fedc4512f5154aa9d3e3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af11118be54316daf2c684ab1ed515c1150e151bc58ae7d59e4c9afcb40c5180"
    sha256 cellar: :any,                 arm64_big_sur:  "23e28de98208139a408ecdca12fbe9a7008bbbbca2929a4cc7a85b29bf57edf6"
    sha256 cellar: :any,                 monterey:       "f123f4e93272456caacfad30ae63252ea51001a0f5b2838f147c337ee6e2bf92"
    sha256 cellar: :any,                 big_sur:        "534fd2192131f7d6a3b07e75bc02e1f184996f3bcadc01ef396cad541946f518"
    sha256 cellar: :any,                 catalina:       "c9dc8748b00eddcc57d4d006c1f36bec576b4180bcd33458766e6c17d029c47b"
    sha256 cellar: :any,                 mojave:         "7bd730c346c35c5a87d693e4c9bb4f87ae38031204bed90391027ad18c2786be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15a45c4557baf53c2ad7131bb167ad88ca2d9521e51bf738fb4ec35f23750eda"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkdatabox.h>

      int main(int argc, char *argv[]) {
        gtk_init(&argc, &argv);
        GtkWidget *db = gtk_databox_new();
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
    gtkx = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
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
      -I#{gtkx.opt_include}/gtk-3.0
      -I#{gtkx.opt_lib}/gtk-3.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}
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
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lgtkdatabox
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    # Disable this part of test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
