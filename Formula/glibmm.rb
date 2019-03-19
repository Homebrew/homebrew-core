class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.60/glibmm-2.60.0.tar.xz"
  sha256 "a3a1b1c9805479a16c0018acd84b3bfff23a122aee9e3c5013bb81231aeef2bc"

  bottle do
    cellar :any
    sha256 "53f25847c421d3d56383031d69808c9d78488a2097968a8e7f446b367cd0bea5" => :mojave
    sha256 "5682d288f3f9f471919f2a3efb6483200b3eef3a21ae30668f0016104a82d5b3" => :high_sierra
    sha256 "6874494fefa0d272fe9a19c0148653c0cf50598f77b45be5680ed201fc885d0e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
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
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
