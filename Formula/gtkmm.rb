class Gtkmm < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/2.24/gtkmm-2.24.5.tar.xz"
  sha256 "0680a53b7bf90b4e4bf444d1d89e6df41c777e0bacc96e9c09fc4dd2f5fe6b72"
  license "LGPL-2.1-or-later"
  revision 8

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a99c01f03822751ae2add9413279226e3dc62bb46f96f24f4dab38d71a787487"
    sha256 cellar: :any,                 arm64_big_sur:  "ae2cb84a696c040281a8131961c755865f4ba96ef223e77cf8e5a8d02b88edb8"
    sha256 cellar: :any,                 monterey:       "dcae86ed827870c397430d8f3d32005ca01d101b17fdda8c336f6a27bd140ab1"
    sha256 cellar: :any,                 big_sur:        "cf3e818aadeda99afd5c51cdfd8ae950bdf56ce16c090d78f23e5a80631f6f13"
    sha256 cellar: :any,                 catalina:       "bc967efcc4b25a56a79089c73db15a7fc61d5d83a62bd5c899777f7169f2e437"
    sha256 cellar: :any,                 mojave:         "1ed0b8b0445bcb223f2d20112004ead1c8b5d598f9e0012180831e069375b6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81c914f8dc798c013483fb31330a152eb4c1bdc62bd68a0a96de61202c94659b"
  end

  depends_on "pkg-config" => :build
  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "glibmm@2.66"
  depends_on "gtk+"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtkmm.h>

      int main(int argc, char *argv[]) {
        Gtk::Label label("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    atkmm = Formula["atkmm@2.28"]
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm@1.14"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.66"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++@2"]
    pango = Formula["pango"]
    pangomm = Formula["pangomm@2.46"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{atkmm.opt_include}/atkmm-1.6
      -I#{atkmm.opt_lib}/atkmm-1.6/include
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.0
      -I#{cairomm.opt_lib}/cairomm-1.0/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_include}/gtk-unix-print-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gdkmm-2.4
      -I#{include}/gtkmm-2.4
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/gdkmm-2.4/include
      -I#{lib}/gtkmm-2.4/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pangomm.opt_include}/pangomm-1.4
      -I#{pangomm.opt_lib}/pangomm-1.4/include
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{atkmm.opt_lib}
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{pangomm.opt_lib}
      -latk-1.0
      -latkmm-1.6
      -lcairo
      -lcairomm-1.0
      -lgdk_pixbuf-2.0
      -lgdkmm-2.4
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lgtkmm-2.4
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    on_macos do
      flags << "-lgdk-quartz-2.0"
      flags << "-lgtk-quartz-2.0"
      flags << "-lintl"
    end
    on_linux do
      flags << "-lgdk-x11-2.0"
      flags << "-lgtk-x11-2.0"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
