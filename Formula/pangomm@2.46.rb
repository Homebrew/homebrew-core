class PangommAT246 < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.46/pangomm-2.46.1.tar.xz"
  sha256 "c885013fe61a4c5117fda395770d507563411c63e49f4a3aced4c9efe34d9975"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/pangomm-(2\.46(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cfefd6ec5d9e367caea2a329f4e13bd741c0e0cfacf9640f484f9716d3467f5b"
    sha256 cellar: :any,                 arm64_big_sur:  "a06a2a84e675036071a0c1926ddad0234afc6f039dc8f893256a99fa2a811e8f"
    sha256 cellar: :any,                 monterey:       "2664875b0591aaf1b36070942acdd0d23354e863d80af669a4de36482fc60858"
    sha256 cellar: :any,                 big_sur:        "a59a4d40e0438b99f7cf5027d68e9a3c5701911a732e21908126eb2408862a55"
    sha256 cellar: :any,                 catalina:       "cfa4595bc6f7dd8e5eb2d8c05426a4879112bebe57711b8fa8a944eecc8b1acd"
    sha256 cellar: :any,                 mojave:         "29ea5bd59f1116d43d019345e6e3a338ac4199a7a5070112082063769637ab94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277e2b45b4fdb94cc2fb2799c464e3eb7ff3cd33513bd9ae06d0edd251a88d08"
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
