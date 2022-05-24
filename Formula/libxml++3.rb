class Libxmlxx3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.3.tar.xz"
  sha256 "9541f6d2eede269498bb32e4193a41b631453654f407d47a876d62ab73beb7b5"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0b14f3d7a4bcb1529e751786f2d9f483bfa96136140c26753d3cdbc7e707bbde"
    sha256 cellar: :any, arm64_big_sur:  "226605da2683fe051605e9ea508a3949fdb44a684ae9b9c0d96d31ec2b5f0319"
    sha256 cellar: :any, monterey:       "d6a4c5e824973e341e490cbe02b5205df919b83dfebbca78331410b177cb0eb6"
    sha256 cellar: :any, big_sur:        "9fe6ae506a1bf7f4f98d5e4f513d8c9954ae018482dea876973d4a735e1f744b"
    sha256 cellar: :any, catalina:       "049d46347637f0bf778b24ea3c0ae18512d2439c3aaae7014495bc57480e27e6"
    sha256 cellar: :any, mojave:         "8f91b7a9ee057c3b8e248ac9757d7a549f5caf5924d26d50a41add7dfe10f8f5"
    sha256               x86_64_linux:   "02ec72ecc0be11f6d0ffc4f0a635335f7ca4a21875e85c1e1e3d35e416a536b7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

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
    glibmm = Formula["glibmm@2.66"]
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
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
