class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "http://gerbv.gpleda.org/"
  # 2.6.1 is the latest official stable release but it is very buggy and incomplete
  url "https://downloads.sourceforge.net/project/gerbv/gerbv/gerbv-2.6.0/gerbv-2.6.0.tar.gz"
  sha256 "5c55425c3493bc8407949be8b4e572434a6b378f5727cc0dcef97dc2e7574dd0"
  revision 2

  bottle do
    sha256 "bc231df3d775ec46aa67065c91ba371dda31fa22ef262726ae261ebbc680b02c" => :mojave
    sha256 "98a3d08ffa212c3a7f2bfb47995492a12b1d4aa81b85d2df588a72bb99ea5b14" => :high_sierra
    sha256 "3c65545b5750557a964aa4829ff8a78a51899fbc75034f378c0a3b540ea71f06" => :sierra
    sha256 "504028d3be0a380d8c809a6766abaa6f2e6768be852e20be9638be6a99761699" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.append "CPPFLAGS", "-DQUARTZ"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-desktop-database"
    system "make", "install"
  end

  test do
    # executable (GUI) test
    system "#{bin}/gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
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
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/gerbv-2.6.0
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
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgerbv
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
