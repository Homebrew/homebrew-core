class CairommAT114 < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.14.3.tar.xz"
  sha256 "0d37e067c5c4ca7808b7ceddabfe1932c5bd2a750ad64fb321e1213536297e78"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(1\.14(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0b85a16abade85d8a54c06c5dd2ad262c3679f011e5a9e3b4b87bb90f441a163"
    sha256 cellar: :any, arm64_big_sur:  "71bcd76e90894734f2e5d63935bc183cd8486235f9a664d4e205db1b96a0c822"
    sha256 cellar: :any, monterey:       "cb2b5dbb06c874a8e133bfa71c8c4969a4cf1b8156ab4d52ff2a36b08e9dc90b"
    sha256 cellar: :any, big_sur:        "67f908984fdf0cefc9d18cc14bc59517f5b41a821acee8b6f98538f3bfea864a"
    sha256 cellar: :any, catalina:       "61e7e813f3a0a75951b2a25ef451bc97268330768cb2963fd00e8debf4d26a92"
    sha256 cellar: :any, mojave:         "919c048378cc28132ddbff1138796dcdc1f1d330a6f60b97b0ddfa2c77394780"
    sha256               x86_64_linux:   "55a72b3ff6eb503eebf7aced50b3bad26f50422804e9802d1c92ebe242146595"
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
