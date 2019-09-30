class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.0.tar.xz"
  sha256 "4c4cfc917fd42d3879ce997b463428d6982affa0fb660cafcc0bc2d9afcedd3a"
  revision 2

  bottle do
    cellar :any
    sha256 "65dca5000702ffcabc191ed84c33cef365056f4c853c8630a094c6e917b5e6c7" => :catalina
    sha256 "41fa55c1a359635acac27990de9ef7d4c84c6e45f43b54b4fecd0c85010d5ed0" => :mojave
    sha256 "cc4325eb5abdb8248ea4d4ec36f5ab37abfce03459034c700b92cfaa757392e8" => :high_sierra
    sha256 "918691593ee2144c7aae041f3f83a3f961af0408329b69907a893669f267f5b1" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
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
    libsigcxx = Formula["libsigc++@2"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
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
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
