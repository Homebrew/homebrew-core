class CairommAT114 < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.14.4.tar.xz"
  sha256 "4749d25a2b2ef67cc0c014caaf5c87fa46792fc4b3ede186fb0fc932d2055158"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(1\.14(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a8c43545efbcc3695ddeedfcd6a27fe3211145d0bf416f0d4be61a43490b04f8"
    sha256 cellar: :any, arm64_monterey: "d73e7ad45c201015054832b11193662b57aef16af7b6da445cc42ce9b5cd542e"
    sha256 cellar: :any, arm64_big_sur:  "59edc5af615287822b6642b60e0fcee69e1791ac3b6dfab8e1a001ee9c5b6692"
    sha256 cellar: :any, ventura:        "7290f0a786a2d715541c32a05e5460508ae6b1bf5efd497df5cfd896c5936b72"
    sha256 cellar: :any, monterey:       "15e588602433c74a5b2736744d883f26a841936b37cf04331ae5679867e210e4"
    sha256 cellar: :any, big_sur:        "b47b2e6f6ef5e8138fd220cb2d96d263d6def3b729dfd0dcd5d6ae6608641f0c"
    sha256 cellar: :any, catalina:       "4e392cfc8a9b4e0b7f09ec0360e5e314bf8a3f500ca2949e40f100d3215a1ae3"
    sha256               x86_64_linux:   "e1ba87798dcbf6ab86bb98aab12f0f4ffb578f6681f5a5576e0893e7916e089f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libpng"
  depends_on "libsigc++@2"

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
         Cairo::RefPtr<Cairo::ImageSurface> surface = Cairo::ImageSurface::create(Cairo::FORMAT_ARGB32, 600, 400);
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
    libsigcxx = Formula["libsigc++@2"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairomm-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/cairomm-1.0/include
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lcairo
      -lcairomm-1.0
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
