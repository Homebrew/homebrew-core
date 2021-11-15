class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.48/pangomm-2.48.1.tar.xz"
  sha256 "776ad53e791e43106b7f40ff0834bee6e4eb1c6ad7cb6d215546f7a3df0edc4d"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7e02371fb268fcec2738683d4e9760a692a6ce9a55ff1fa46697abc07a756829"
    sha256 cellar: :any,                 arm64_big_sur:  "87244c82b6ac45d8de28f5870747b96fe8bded40041dd3de159fd501b7b58754"
    sha256 cellar: :any,                 monterey:       "e65d3cc4231fad9f057e5000a62c838770575001de6e059907c535820d3274f3"
    sha256 cellar: :any,                 big_sur:        "d8ea58c9fd6cece698a1605b0b3513e5818d8e0c060dc5e7357e1b0aa7325233"
    sha256 cellar: :any,                 catalina:       "304b7e078c0c4dcbbf44e30b4912adf475f41eeda5728e65f68d45f3abcd8af4"
    sha256 cellar: :any,                 mojave:         "6060adeb759d72e6ce9f6f7c8e076ab736b7a36107d9f1e0346ce9d9a5eaa51b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c430e21614121e2c6d80d456f36a36644defc60173ba969557ce58a7f6da73cb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  on_linux do
    depends_on "gcc" => :build
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
      -I#{cairomm.opt_include}/cairomm-1.16
      -I#{cairomm.opt_lib}/cairomm-1.16/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.68
      -I#{glibmm.opt_include}/glibmm-2.68
      -I#{glibmm.opt_lib}/giomm-2.68/include
      -I#{glibmm.opt_lib}/glibmm-2.68/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pangomm-2.48
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/pangomm-2.48/include
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
      -lcairomm-1.16
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-2.48
      -lsigc-3.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
