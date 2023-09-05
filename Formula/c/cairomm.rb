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
    sha256 cellar: :any, arm64_ventura:  "9dc02a86bd973dbfa704c5f35ad179e0612d2577479a7fa37e72bfa743792c2e"
    sha256 cellar: :any, arm64_monterey: "15c06fb5618cea8d83bbe19ffdbd535c1d93b434aa0df8b96575c80eecf4cf95"
    sha256 cellar: :any, arm64_big_sur:  "d98ab34ab8edca70f4deeff30d48d7f1e468b34b9c0608a37bc3ee3a26f14198"
    sha256 cellar: :any, ventura:        "7408a614e6ad2d14098f1098c6160cd293b7cd8b216df4eb69fb801b9b8bd929"
    sha256 cellar: :any, monterey:       "7f2071609a31de758c475126240c62cc32d2e3b82b2743758b74d4f27268cc77"
    sha256 cellar: :any, big_sur:        "5454993c9b1ce583f5f10b59d365da862e80449c63027ba168dcf9f99dd46132"
    sha256 cellar: :any, catalina:       "9947e644615c28b6f8ee304b619fcf484250fd33af54e07553bcdba5e58c7dd4"
    sha256               x86_64_linux:   "fc5ae13abc967d5945d36f42be123a9dd26c4ed2d31d1c13955d88f32c363196"
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
