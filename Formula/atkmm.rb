class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.2.tar.xz"
  sha256 "6f62dd99f746985e573605937577ccfc944368f606a71ca46342d70e1cdae079"
  license "LGPL-2.1-or-later"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any, arm64_monterey: "060aaa8eff1cde559d778477b5d3b0b707de855a590a13a9ff9b416ce7a4d2ee"
    sha256 cellar: :any, arm64_big_sur:  "664288c4e6fb17a1d7b496e77ed85ca6f1133aeb56f96ba643cd0d1878544935"
    sha256 cellar: :any, monterey:       "59d500b3a99b28004129b67bdd0e7b01e380641775c3a8f419c8ef946ebfb885"
    sha256 cellar: :any, big_sur:        "6faaf66dbd24fd9a6653cd123c5ea7e3d859f6271889315ebdf53a1c66548ea3"
    sha256 cellar: :any, catalina:       "b90948dbd7c51cc8a6a1cddadb90942b8edec8e682b37f168be4fd5eca3c6cee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

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
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
