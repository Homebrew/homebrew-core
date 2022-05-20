class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.2.tar.xz"
  sha256 "a0bb49765ceccc293ab2c6735ba100431807d384ffa14c2ebd30e07993fd2fa4"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/atkmm-(2\.28(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c998a07090f1a5979f5fffc63ae20a16e05683904391c1e6af55201c91111803"
    sha256 cellar: :any,                 arm64_big_sur:  "e983693a33a42234e168ab6691a030a7e90f6ed0730dc3011034ec14478472b6"
    sha256 cellar: :any,                 monterey:       "2a89fdca2f46e5a75c864fe197d2f7e2584d07f68c0fa693480d6da4adf75581"
    sha256 cellar: :any,                 big_sur:        "ee8b64bf67e30fb46e3e8b1ec34c902055cad8ec635a8de8331073406e6a81f2"
    sha256 cellar: :any,                 catalina:       "e6f94253d0a96d89131fe72fcf212028e87f41875761e57dd5f0cc40b46bfaf2"
    sha256 cellar: :any,                 mojave:         "2b7ac6cd13ae986cef9784908877b3e4b58d42846b23f733e6f8c17600a44cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39ac64ae650ee9f8d40447d346fc2166bc24a016d2e29cb2d23836c290be5e3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm@2.66"

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
    glibmm = Formula["glibmm@2.66"]
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{lib}/atkmm-1.6/include
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
