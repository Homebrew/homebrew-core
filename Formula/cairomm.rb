class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.16.1.tar.xz"
  sha256 "6f6060d8e98dd4b8acfee2295fddbdd38cf487c07c26aad8d1a83bb9bff4a2c6"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d285d418a00fa705e40e1216d4949b0c80a7f12580c0f7021edf4c8083b833f9"
    sha256 cellar: :any, arm64_big_sur:  "70e65e43376e9f2159955ee6ec8db9f4c440c24df8dfebdc06fa10953604eba9"
    sha256 cellar: :any, monterey:       "52f956ccf9aeaad9be54850ff27867020b832f685b4f16dc22d024e666240f8e"
    sha256 cellar: :any, big_sur:        "6b0e30e7ed71aed6bf7dfb862eba5d2c62dd0abc7a6d13684448ac6f5430f045"
    sha256 cellar: :any, catalina:       "e02d87fa8a812686d9a2bf9ccfbe56e2937156e75488ee0795fb061d087cc171"
    sha256 cellar: :any, mojave:         "53433da3d97a46f2878505f42882162eda2b145e7fbc3380034c79c9626120af"
    sha256               x86_64_linux:   "ccbec4be03fed226dc702b2b03cd55e64a35aa4b2e3fdbf9b11c2c27c3e61fdc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsigc++"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
      #include <cairomm/cairomm.h>

      int main(int argc, char *argv[])
      {
         Cairo::RefPtr<Cairo::ImageSurface> surface = Cairo::ImageSurface::create(Cairo::Surface::Format::ARGB32, 600, 400);
         Cairo::RefPtr<Cairo::Context> cr = Cairo::Context::create(surface);
         return 0;
      }
    EOS
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairomm-1.16
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/cairomm-1.16/include
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lcairo
      -lcairomm-1.16
      -lsigc-3.0
    ]
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
