class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.58/glibmm-2.58.0.tar.xz"
  sha256 "d34189237b99e88228e6f557f7d6e62f767fe356f395a244f5ad0e486254b645"

  bottle do
    cellar :any
    sha256 "ff9adfa73059275ed61ce0b2d1098a65ab04381593e0c0871070a9efc0c7c053" => :mojave
    sha256 "2c49d64310a4ed25cff3b1b82591a779b4febcdfde5cbf02249cc1c70af08671" => :high_sierra
    sha256 "b3458579f8b8db463aad37b6ede1beba71ede39a54ba35834024b2d418e0d217" => :sierra
    sha256 "7147107e5cafa29049f436f811169570f5fb5e7ec7a371b96906511bc51dd9ea" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++"

  needs :cxx11

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
