class Libxmlxx3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/3.0/libxml++-3.0.1.tar.xz"
  sha256 "19dc8d21751806c015179bc0b83f978e65c878724501bfc0b6c1bcead29971a6"

  bottle do
    cellar :any
    sha256 "f245f11b721c777aa306f69edf6f18a8378f715f0b6e6eda67abc89dd7c20cd0" => :mojave
    sha256 "81a832266045b5cc62d2c1b487ac2a221533ef5039f344bcfce98091549a32b7" => :high_sierra
    sha256 "1d5baca91832c79cc7ae0257f3b0f35d67184f25db8aa75bdabe2e2d581caf7b" => :sierra
    sha256 "9a1c98fc76dc4dede0d4092c1c015a690bcb8a8fe24be1a37235fe9846a302c0" => :el_capitan
    sha256 "3f9d20753370b2ff1ff3e3e9bb0df129787f3b2904d5f0ee475b9099ca66dbfc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-3.0
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-3.0/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
      -lxml++-3.0
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
