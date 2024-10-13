class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.net/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.3.tar.xz"
  sha256 "74b95302e24dbebc56e97048e86ad0a4121fc82a43e58d381fbe1d380e8eba04"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "3d646ead3d15603ed585f7e1c8cd6c0a4304b5aa91478665e4bdc1e9daadc31d"
    sha256 cellar: :any, arm64_sonoma:   "ecc4bfa5bec6222f62d35af0afa054dd14dbbc768619e59b751535af9e1d2c40"
    sha256 cellar: :any, arm64_ventura:  "90bb4a37548aef72c8884931767231a8db350f92587fe71540384fa4a665f089"
    sha256 cellar: :any, arm64_monterey: "3c9aed5436d578af2db72c4beacb9597d3641c452a5ae89f53c2e7f760e7b6e6"
    sha256 cellar: :any, sonoma:         "f94ee80dbab0f76742730875f9c96bbf9ffb150cabaeb59934f3465a5bad628e"
    sha256 cellar: :any, ventura:        "0a44a4c9705798b962ec67053415810a8ce79211df06f7b9401f4ff1d3059098"
    sha256 cellar: :any, monterey:       "2c2578ab09f0b69f9155aee5d0591c63b9f6da95f0e6b0c2193d78c96125c4c8"
    sha256               x86_64_linux:   "3005c784682af5d78591f50de19cbd70a72dad5032a58b2be657e467c17a4bcb"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glibmm@2.66"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
      -I#{include}/libxml++-2.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-2.6/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lsigc-2.0
      -lxml++-2.6
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
