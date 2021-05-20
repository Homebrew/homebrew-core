class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.68/glibmm-2.68.1.tar.xz"
  sha256 "6664e27c9a9cca81c29e35687f49f2e0d173a2fc9e98c3428311f707db532f8c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ad82e21e43601e8804150bea12157afa6c38201a441d97a91521ecea93bbfc13"
    sha256 cellar: :any, big_sur:       "59b86d3d2fe4f28e8a19ba0f5faf0174f7829bb46ae3b04f06bdcf5f3c24935b"
    sha256 cellar: :any, catalina:      "f4d4326c91b4c573e07a832a0b204bd5a8bc75da331e87f18c044e1397951bc2"
    sha256 cellar: :any, mojave:        "ff82b1c3e7e8467ac8cd91f01cd97ca2bb4329861b2dd99bda0be89954f730b6"
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
