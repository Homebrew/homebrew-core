class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "http://gwyddion.net/download/2.51/gwyddion-2.51.tar.gz"
  sha256 "67c1319b3a3e5682a37390b34d2580208a624c7d56dae8b5a3389fa5856508ee"
  revision 1

  bottle do
    sha256 "a0cdc1c579926f9f9e8bc42c98d287b4312257b8bad06570d64e90cf97fa7068" => :mojave
    sha256 "29e031b68d9a65cec743209a818efd48a0acad4dfba11e7b266cfc00a81ef809" => :high_sierra
    sha256 "259250a3db045fe51b5086b8fbba50e94e673bcb729519c669ff22d72e2886fd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "gtkglext"
  depends_on "gtksourceview"
  depends_on "libxml2"
  depends_on "minizip"
  depends_on "pygtk"
  depends_on "python@2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make", "install"
  end

  test do
    system "#{bin}/gwyddion", "--version"
    (testpath/"test.c").write <<~EOS
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fftw = Formula["fftw"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    gtkglext = Formula["gtkglext"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fftw.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkglext.opt_include}/gtkglext-1.0
      -I#{gtkglext.opt_lib}/gtkglext-1.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gwyddion
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gwyddion/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{fftw.opt_lib}
      -L#{fontconfig.opt_lib}
      -L#{freetype.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkglext.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lfftw3
      -lfontconfig
      -lfreetype
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkglext-quartz-1.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkglext-quartz-1.0
      -lgwyapp2
      -lgwyddion2
      -lgwydgets2
      -lgwydraw2
      -lgwymodule2
      -lgwyprocess2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangoft2-1.0
      -framework AppKit
      -framework OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
