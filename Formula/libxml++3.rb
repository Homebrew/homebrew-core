class Libxmlxx3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.4.tar.xz"
  sha256 "ba53f5eaca45b79f4ec1b3b28bc8136fce26873cd38f2e381d9355289e432405"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1fd76178d8426c9fa0eec6f2c7623c41a3abbaf8d6dc1f8da1dd225d45b31997"
    sha256 cellar: :any, arm64_monterey: "ddc19560601574a064a39f843c4d491c06f003bbf4e0fe33adb8ff182263fd58"
    sha256 cellar: :any, arm64_big_sur:  "e5cfbb31bd5395b6d9719b187250651b12c61940677803d7631560dc80b70902"
    sha256 cellar: :any, ventura:        "26de0bd31d10a666e13d22aa9b61d9a02d5a29507328f687fd49236b825aaf22"
    sha256 cellar: :any, monterey:       "e3102753d4767695b1be39de17cf60a1b95b52dbcd44f78d8305ec6484fa69e0"
    sha256 cellar: :any, big_sur:        "00d13dc18b4552eb53fa4fcf82d85ba19449e2c0554e9eb62ac7d0660cd3c2af"
    sha256 cellar: :any, catalina:       "f05f17bc7bd03b90dad695b4387defd06fb07b5f0b9f8e291745a712441c4592"
    sha256               x86_64_linux:   "1d6f3a492fe6f702cadc0dac917434a9087d6b1756d32d83e4abecbfe2a8684f"
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
