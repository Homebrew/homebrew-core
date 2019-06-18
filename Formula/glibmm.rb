class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.60/glibmm-2.60.0.tar.xz"
  sha256 "a3a1b1c9805479a16c0018acd84b3bfff23a122aee9e3c5013bb81231aeef2bc"
  revision 1

  bottle do
    cellar :any
    sha256 "976b138f9cb6d0456b93d41fd4fe288b72774bc4e1fca8ba028f18956463e139" => :mojave
    sha256 "c68640ee525534c89c2e737760c375217588ddd29b30a71a3d68f7d2b412c827" => :high_sierra
    sha256 "c186a363d1eb3608aaa4ec6cb368babbce60d96e3a6e224ecd00eafac475037d" => :sierra
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
