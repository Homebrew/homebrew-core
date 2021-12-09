class PangommAT246 < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.2.tar.xz"
  sha256 "57442ab4dc043877bfe3839915731ab2d693fc6634a71614422fb530c9eaa6f4"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/pangomm-(2\.46(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c794e69f80086920c974a7a8982034cee2a72c3543156346768ce6c11fd04e62"
    sha256 cellar: :any,                 arm64_big_sur:  "28a5885682e8cabb5240af2d46c4d982f4a74e87e0909d573a5d8f11941dab22"
    sha256 cellar: :any,                 monterey:       "2670e2d8fcc5bcfe06c37c6b68c3871286312202329033341ed52a22db42be0b"
    sha256 cellar: :any,                 big_sur:        "41a5c473ca7eb840d0238df3147aeab957c757afc0eb65fff3c5dce3ed0f7c83"
    sha256 cellar: :any,                 catalina:       "93c8dc4f62582d30a9c48995923bba460e8a10600c9406d6d690c5406f231614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2564f1187494082130a06400670c5b7b9d7a6e82f4c49172799ef00c3eacb22"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairomm@1.14"
  depends_on "glibmm@2.66"
  depends_on "pango"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm@1.14"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm@2.66"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++@2"]
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
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-1.4
      -lsigc-2.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
