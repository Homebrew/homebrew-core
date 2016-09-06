class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.40/pangomm-2.40.1.tar.xz"
  sha256 "9762ee2a2d5781be6797448d4dd2383ce14907159b30bc12bf6b08e7227be3af"

  bottle do
    cellar :any
    sha256 "7565443483138210e191d3fe044c04d55755057b4c3d53187baf2857c966f0a5" => :el_capitan
    sha256 "09d9b38d15273c02968cb4330159c8cfa0b9e06701f69b7495c12f64f7f370b8" => :yosemite
    sha256 "1d2a6f8d96059a189be9d39e6d20fd5a8a7a14293cc64c71eab506522ff5c1e5" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  depends_on "cairomm"
  depends_on "pango"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.0
      -I#{cairomm.opt_lib}/cairomm-1.0/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pangomm-1.4
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/pangomm-1.4/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lcairo
      -lcairomm-1.0
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
