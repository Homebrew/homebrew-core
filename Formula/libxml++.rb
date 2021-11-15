class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.1.tar.xz"
  sha256 "9b59059abe5545d28ceb388a55e341095f197bd219c73e6623aeb6d801e00be8"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b7da42c199f838866894627be4939e7eca4a3bda8524f125781b21ec29f5383d"
    sha256 cellar: :any, arm64_big_sur:  "e2aba0455833404cb02800c272d4b1c8e4f8216da5bc15798f8e64c0d784ecb2"
    sha256 cellar: :any, monterey:       "20ac747ac5363fd842bf1e71ee0836b211bc3a8b74328aea43b7d7f671fb1365"
    sha256 cellar: :any, big_sur:        "2b16a17ecc1683587eb672acc18ba98ee88795c54cb7edac974ed4e3459bfc3a"
    sha256 cellar: :any, catalina:       "d6e621d8511f48b17f1e33a87efb04fcc9b65a1afe6ca6d442f4d9e7ce98b3e4"
    sha256 cellar: :any, mojave:         "f76bb4f5672bd0d2c50ba19efdc192e6eb31166043ace553a33fc9e7d4604cfb"
    sha256               x86_64_linux:   "dc1b0fe9971c2cd23cc9dfc94b72e8052e4ab76f5e2fab39fe382bfd44e1f21f"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
