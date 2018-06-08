class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.56/glibmm-2.56.0.tar.xz"
  sha256 "6e74fcba0d245451c58fc8a196e9d103789bc510e1eee1a9b1e816c5209e79a9"
  revision 1

  bottle do
    cellar :any
    sha256 "611cb45e6240e9fc41a1e38fdcfdaa303e4b5b8a98ef7c40f497d59490c2c3bc" => :high_sierra
    sha256 "46991472465a244c04cbbef29e15d5194bc9af3a66b1cae0b277779882cdd075" => :sierra
    sha256 "25b785a0b869d958dc61f782413c5af4e65d742c8aaf3afe30240b764651d235" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  # Remove for > 2.56.0
  # Upstream commit from 26 Apr 2018 "ustring: Fix wchar conversion on macOS with libc++"
  # See https://bugzilla.gnome.org/show_bug.cgi?id=795338
  patch do
    url "https://github.com/GNOME/glibmm/commit/f1530eca.patch?full_index=1"
    sha256 "ae8990b93e29b47903da7eed8676cf806b34fd3b45d6bd5fb3d7a4f040b9f4c9"
  end

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
