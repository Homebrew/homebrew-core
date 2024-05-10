class Gtkdatabox < Formula
  desc "Widget for live display of large amounts of changing data"
  homepage "https://sourceforge.net/projects/gtkdatabox/"
  url "https://downloads.sourceforge.net/project/gtkdatabox/gtkdatabox-1/gtkdatabox-1.0.0.tar.gz"
  sha256 "8bee70206494a422ecfec9a88d32d914c50bb7a0c0e8fedc4512f5154aa9d3e3"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4c95de47b74f0a924c88543dfbfc01999cf3491ce8bac5e77b0db2a265bb0e9"
    sha256 cellar: :any,                 arm64_ventura:  "058fb1cf99c7c1a34a9c7b81ebbb8720863009241ad47d69b47efb2f448ff84a"
    sha256 cellar: :any,                 arm64_monterey: "1951c01226523dbbf91a85816a64fed3377b9c4fec4180536b608b93151eafb0"
    sha256 cellar: :any,                 sonoma:         "bfaacbe85617357013ed6368753b261bc87963366680eac5f73cf85183710f96"
    sha256 cellar: :any,                 ventura:        "7a86f4f2915d37de33ae84232fa05588e576a2e0698321501b3a75e0aedd9ace"
    sha256 cellar: :any,                 monterey:       "abc35085101b1fdde0163eb859927e6dcc35e2d38451d033b78206cb24814fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1585023f5e6799a8eab163fae37ba597262d3352a01f2bee7763359224f94388"
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
