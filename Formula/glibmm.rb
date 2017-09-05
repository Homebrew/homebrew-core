class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.52/glibmm-2.52.1.tar.xz"
  sha256 "dc19d20fb6b24d6b6da7cbe1b2190b38ae6ad64e6b93fecdcce71b995f43c975"

  bottle do
    cellar :any
    sha256 "dea843cb8f9ee9b9345bd71571eb96fb8a84ed91e296a3792753bbbe7b5affdf" => :sierra
    sha256 "f4ae5ec159874f0b8cb1293b63d62703c24fcaa443ecdddfdf65b277d4c075d5" => :el_capitan
    sha256 "5ba4d3b82f35ab7bffe3d8bb392151073fad6d8561ba3fe893f626174726777b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
