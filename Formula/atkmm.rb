class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.24/atkmm-2.24.2.tar.xz"
  sha256 "ff95385759e2af23828d4056356f25376cfabc41e690ac1df055371537e458bd"
  revision 1

  bottle do
    cellar :any
    sha256 "c3a1e1fe87f1f53c7a272381a56257b7ddbddfbfc0790215b1a3b8e7b1792e4f" => :mojave
    sha256 "b6b2da1cde33893f1c499a6df77de45568b20afcfc87e2bfc911a25631b9a1af" => :high_sierra
    sha256 "09bfd213a8eb8c7b3ab8b8858593cd9c715b3f2baf00bdeb207dabf35e9d024e" => :sierra
    sha256 "010e3d1649ba47570df271456ba83c28ca23fbbceddee8cad0644ef91ba96eca" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

  needs :cxx11

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
    libsigcxx = Formula["libsigc++"]
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
