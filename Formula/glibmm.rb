class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.68/glibmm-2.68.1.tar.xz"
  sha256 "6664e27c9a9cca81c29e35687f49f2e0d173a2fc9e98c3428311f707db532f8c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3b8849a9c84e3d1df3ad04a0d37b0e006d96d9a7e1881e45d1472e0f4a727d6"
    sha256 cellar: :any, big_sur:       "a19057e4cdbcafddcdf0632c15c68fde2830e290a7516f89e26d5d2dab583b50"
    sha256 cellar: :any, catalina:      "52fe443b93eacccd6a85ac9fa71fc45b66199a12af4fe313bbed3bceac58a368"
    sha256 cellar: :any, mojave:        "51230b1f33200cc431c068bf00bc80c76267aacdea2382b4ec9a3d6323774398"
    sha256               x86_64_linux:  "04b4baf39b3f533b9ec7fb28c13db868da76b30f42ba118f0492e7c67f671a2b"
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
