class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.1.tar.xz"
  sha256 "e11324bfed1b6e330a02db25cecc145dca03fb0dff47f0710c85e317687da458"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62a52bf13cb3e8ae0f3de2c22fe5eb99c82e2bfcf70562e7299b81e3b0eb46ab"
    sha256 cellar: :any,                 arm64_big_sur:  "82e89f908e2a3cc349c8478eef60d7b755f968d3523f037b8b78ea4edc4031ba"
    sha256 cellar: :any,                 monterey:       "8d00072e06cb6fa4748cad51217427499ace42f1177e0f1d6bfbb00363329378"
    sha256 cellar: :any,                 big_sur:        "4b147e97566fe8f13c6e72e1d350da5c8bbabe3abb6f4966eec44f227c9fa807"
    sha256 cellar: :any,                 catalina:       "09b0e72f5d9fd8e2a3328202d8c2b8fc7f896cdd208ab51fa75bb87c79eee53d"
    sha256 cellar: :any,                 mojave:         "a3ed94c51be9ae22f3a3c1d6650ade4037748f2c8602db9b647effd71b4d5108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e8f09c113ecfd68cac31cc2e96daecc200a4260a076ef5c58bf852774fbdc1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

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
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["atk"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.68
      -I#{glibmm.opt_include}/glibmm-2.68
      -I#{glibmm.opt_lib}/giomm-2.68/include
      -I#{glibmm.opt_lib}/glibmm-2.68/include
      -I#{include}/atkmm-2.36
      -I#{lib}/atkmm-2.36/include
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-2.36
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lsigc-3.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
