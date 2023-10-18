class Cairomm < Formula
  desc "Vector graphics library with cross-device output support"
  homepage "https://cairographics.org/cairomm/"
  url "https://cairographics.org/releases/cairomm-1.18.0.tar.xz"
  sha256 "b81255394e3ea8e8aa887276d22afa8985fc8daef60692eb2407d23049f03cfb"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?cairomm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9da9227f04ce5e2dfd54e6d1e39ce19ccb9edb062acf7751105c45174d971824"
    sha256 cellar: :any, arm64_ventura:  "b335188e992781cf00c6157bc3672aeb97462de721113c605a81f73b25a3188b"
    sha256 cellar: :any, arm64_monterey: "badd15644a940fcdb2fbe0ad21e9c24073098a421dd6bc705ea4cf6bd9cd4699"
    sha256 cellar: :any, sonoma:         "0e38e709e43a068694a9a36c743930e133e0c1da6647de9ea82391e7a82052c9"
    sha256 cellar: :any, ventura:        "61f902ee74afad872595fa8664f5a3a7d702df38ab5299b445cf82d258e08d45"
    sha256 cellar: :any, monterey:       "f94ec9449571497fdf24911966394002d0d67c26081e21d7c5e471109a78e3f4"
    sha256               x86_64_linux:   "a7f537f71f9176e26a94e7b5db2a30f0ea266085486ca78af8e957e401d7de63"
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
