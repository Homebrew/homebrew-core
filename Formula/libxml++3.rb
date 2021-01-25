class Libxmlxx3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.2.tar.xz"
  sha256 "a53d0af2c9bf566b4d5d57d1c6495b189555c54785941d7e3bef666728952f0b"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "7c1c805e82abcb022693b2c406cdb315b722a82bf510f0b6fbf65a04bb5be4d5" => :big_sur
    sha256 "3dc301c85f0b5f9da58de539e50df1b9f22e7fa8d7840f498bfdb4b118dfe4e9" => :arm64_big_sur
    sha256 "ec019c33706d717ab23eb6666fb7a99984b12928bb7c12f65d97e8804b0e5021" => :catalina
    sha256 "a4785f6c1dfdc802e564d637a3be7047dca1cdc24bf680ca4ab4130921812d3a" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glibmm@2.64"

  uses_from_macos "libxml2"

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
    glibmm = Formula["glibmm@2.64"]
    libsigcxx = Formula["libsigc++@2"]
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
      -lsigc-2.0
      -lxml++-3.0
      -lxml2
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
