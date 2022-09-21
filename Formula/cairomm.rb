class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.16.2.tar.xz"
  sha256 "6a63bf98a97dda2b0f55e34d1b5f3fb909ef8b70f9b8d382cb1ff3978e7dc13f"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "7a67caede999c7ba7519176448e9339693f0db227f09a6828d1ae3429dd35b18"
    sha256 cellar: :any, arm64_big_sur:  "56c5d0ece32f63cb06fb262077630694b3296e06daad0842b0734f2f288646d3"
    sha256 cellar: :any, monterey:       "6f710276849eb221328f91d02d8360afefb22ee7f5443e354a48ca9570e2a605"
    sha256 cellar: :any, big_sur:        "80c9e4d2948354442cba31e225f4343b8bd3985e8f9fd8fa3bb06c9ba50db9ff"
    sha256 cellar: :any, catalina:       "bd8824b5da978158d1e7fdb6d156f9a41783d09a8dc82b4d56aabffc37335434"
    sha256               x86_64_linux:   "3ffb4fbfb4ffc223341488313deb3bcbcd71dd9572d5ce10a1f489897f993e97"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsigc++"

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
