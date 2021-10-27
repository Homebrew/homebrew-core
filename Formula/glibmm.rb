class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.70/glibmm-2.70.0.tar.xz"
  sha256 "8008fd8aeddcc867a3f97f113de625f6e96ef98cf7860379813a9c0feffdb520"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1ebb6889448d05a7fa6772588946d090464ba3acca808692d72ab32d2e6304cf"
    sha256 cellar: :any, arm64_big_sur:  "85cf4f30e430474bb31b4d40331658d4abbbd6656b0fd545e83757289863545c"
    sha256 cellar: :any, monterey:       "0a8cf3b36eef323ccfee7b4489c4783ecf4afb573ee8a74b692c36eb82801152"
    sha256 cellar: :any, big_sur:        "edf7767c19d7af3fa0029a77b900b160856bfc1d65b789e58ad9001c40cd6552"
    sha256 cellar: :any, catalina:       "371c5642bb40285423561696728f0bb760197d5971961819e82846f452d0659b"
    sha256 cellar: :any, mojave:         "6b17198a3468451bf0019b02dbeffe9fa0907876964b63981cebaf53966dcbf8"
    sha256               x86_64_linux:   "f000a536bbbfc6100c9fd63f8b7ec6e674867ab75e86e8132da1ef2b3c409988"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
