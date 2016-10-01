class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.50/glibmm-2.50.0.tar.xz"
  sha256 "df726e3c6ef42b7621474b03b644a2e40ec4eef94a1c5a932c1e740a78f95e94"

  bottle do
    cellar :any
    sha256 "daac145d49d1163cf35fbeba3c6f40d74242469a72c6ef042e15453b8e501e1e" => :sierra
    sha256 "75e5051767721d67395041cb03cfbbc558419ff6cc53911c5ce14dc6e7ff9fa8" => :el_capitan
    sha256 "6a5667eb4d7653b6cb3bc7f03f45dfedf083ec129eefcb0aa8174fa87a4cfa44" => :yosemite
    sha256 "11a80950363e3b8f1561194ecd369948dcf983fba2894cf0e06266a5fde02562" => :mavericks
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
