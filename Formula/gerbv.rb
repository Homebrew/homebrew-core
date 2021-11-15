class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "http://gerbv.gpleda.org/"
  # 2.6.1 is the latest official stable release but it is very buggy and incomplete
  url "https://downloads.sourceforge.net/project/gerbv/gerbv/gerbv-2.7.0/gerbv-2.7.0.tar.gz"
  sha256 "c5ee808c4230ce6be3ad10ab63c547098386d43022704de25ddb9378e62053b4"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{/gerbv/gerbv[._-]v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 arm64_monterey: "6867c2ab1f095c2bd952bc294544146d98c005cb844bea396ead8655db22e92a"
    sha256 arm64_big_sur:  "4b51c047b7ce52537ab152f477fed3fe4ba6b2218cd5445258e672f54acc8c0f"
    sha256 monterey:       "e476fc21dd1ef61b3d6136d0e8bb1643481bfcd873f3482e11c1225906b774bc"
    sha256 big_sur:        "529a2d42b7018cb8edc81eb32e2572c936670c1088bd7934d627d8f358b1eefc"
    sha256 catalina:       "eb27af6bcb6cfc6203297f617d88851e656c5b72fae84b10593429158d1861d6"
    sha256 mojave:         "5995b2ff9b132c129e9e2ca08eb205c58883f63e22eec11c4c53e24ec6dfd4e3"
    sha256 high_sierra:    "246a26e96d930c979db7bdb533807c71418ac0ad5c74bd12749d0c08b903e409"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.append "CPPFLAGS", "-DQUARTZ"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-desktop-database",
                          "--disable-schemas-compile"
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
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gerbv-2.7.0
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
