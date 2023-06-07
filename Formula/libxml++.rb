class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.2.tar.xz"
  sha256 "a433987f54cc1ecaa84af26af047a62df9e884574e0d686e5ddc6f70441c152b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "511445cd841949d87b692d1a10b5eed93fa1eddb8c44b660c0d8632c43ac084c"
    sha256 cellar: :any, arm64_monterey: "7daf9521857c514d0bbd206e995f9981206ed9c2c514e38c6dad17009e5dc75d"
    sha256 cellar: :any, arm64_big_sur:  "1e5d1560ba5277bd2fbbd64700c2d8dc79bf94f21eed9d1a247f04ebb11398e0"
    sha256 cellar: :any, ventura:        "2bb9a91142c4502170553c7573d49de81310af5dc337d11c586bdf1720f4dd86"
    sha256 cellar: :any, monterey:       "0b223c37cc7523b616c272843059559ab6861dc77b7a12b5a52710b2d6df663f"
    sha256 cellar: :any, big_sur:        "6fa7ac0f621ea2e7260ad4d45f1f1a7cb66f08f4c7dfc4ede020859c27b5cd0b"
    sha256 cellar: :any, catalina:       "11650e7441e72a3a19ad51749a7c9ea8e4675fc68d39b4b66e7fb043e468cdff"
    sha256               x86_64_linux:   "6da3628949c4bee0be85fc3ae19aabb2e5fd273f72f029792c9522c3966fbd1f"
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
