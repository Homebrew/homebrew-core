class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.2/apache-arrow-15.0.2.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.2/apache-arrow-15.0.2.tar.gz"
  sha256 "abbf97176db6a9e8186fe005e93320dac27c64562755c77de50a882eb6179ac6"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4bf3d1ffdce1d372b7f795810a2ab95d2b136d2a598dcf37ac40088d24efe9e1"
    sha256 cellar: :any, arm64_ventura:  "6ef71c10b00a50bb7e91c35fd86f6f579b91e42d317d9338fcc9f382fbb6e99b"
    sha256 cellar: :any, arm64_monterey: "a080df8783c0789ed9986a610ea6d57bdf55b6f701d3f5a3bb0ee60a3fa20de1"
    sha256 cellar: :any, sonoma:         "d84e83daec0e31e1d4f0d6ce141b5e6cd36dcc24c3fdd3381cafb9e43dee94f2"
    sha256 cellar: :any, ventura:        "d8f5835365903ca5b86e63c9875d8587852042fa2bf526c7ba15712eac2008a7"
    sha256 cellar: :any, monterey:       "7e8a6b462f471ca3ee006cdad40f961e81028dda2b812c6b30953fb3cd2f091a"
    sha256               x86_64_linux:   "4a0b1b92c11c7c7e7065648194b2c0cc791e7b61dcbde07601f3857b453bc7bf"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
