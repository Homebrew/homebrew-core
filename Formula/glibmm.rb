class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.74/glibmm-2.74.0.tar.xz"
  sha256 "2b472696cbac79db8e405724118ec945219c5b9b18af63dc8cfb7f1d89b0f1fa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e49ef477f2779e88d125131dbb474894fdde113cf667630ef8947821d64cb0a4"
    sha256 cellar: :any, arm64_monterey: "9bed07ed0bc12a9eeb415a900d2a01b5163de1f595cdbdf77523c605410f7b56"
    sha256 cellar: :any, arm64_big_sur:  "94c4d0b2ef01fa6f52f59e3eac7527f5b28c1aa71ccd60de4479402eefc7b34c"
    sha256 cellar: :any, ventura:        "ede6b35b4de6f4ac9418f20db8b3249f3c8160257561d6d94c69663c32c62974"
    sha256 cellar: :any, monterey:       "271bf32165f1e0c4566f7006a3d29346ed9a62f16e1bf14e2ceb710edaec0f0c"
    sha256 cellar: :any, big_sur:        "ec798cefd26699800dd2ea6a6f0898f3c1f422b75e66eab54099b25f8ba7b0cd"
    sha256 cellar: :any, catalina:       "7ef9ed7c63ea3d68e26f153b9bf77c1468f6811abead311f9f5c824b5eaa3550"
    sha256               x86_64_linux:   "af31cc06c35171195312c20dbea1bcf188b6c09e770e160b0c12f64850ee57ec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
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
