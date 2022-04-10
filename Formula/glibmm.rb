class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.72/glibmm-2.72.0.tar.xz"
  sha256 "782924bf136496f3878fdc2a0aa9ef40f0c515e2c3e054caffa5d2e52380c71e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a072d4d69714698e8f2747d5bbf42b81241af0923bd3d8460d441539981a1af9"
    sha256 cellar: :any, arm64_big_sur:  "6f9b5f619d7170385b1b7a49305c0cb108d5e3b1534271cdd4e421e01c16ea0c"
    sha256 cellar: :any, monterey:       "15fdf9804ad1d3f470d9d882226fd808f1bd81864e6fafeab3edf229590c066c"
    sha256 cellar: :any, big_sur:        "9fef5720388f39ffeb92fa833bf498b2b68bf1ecb31a415e297a5b66c75132a9"
    sha256 cellar: :any, catalina:       "796f7854743aa257ca8238ce60fc5a02ce9f74752503c6f8bd65e73432290157"
    sha256               x86_64_linux:   "5cd18764014f0805bce9730c5e69c221c3fe666427ea86b8a3fc0a27301f16c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

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
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.68
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/glibmm-2.68/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lsigc-3.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
