class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-6.0.1/apache-arrow-6.0.1.tar.gz"
  sha256 "3786b3d2df954d078b3e68f98d2e5aecbaa3fa2accf075d7a3a13c187b9c5294"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2e57e2a2438b26fb99701f65c577d273d5862b9b6423fdcf306e92b1f128deee"
    sha256 cellar: :any, arm64_big_sur:  "8c53f4079f63fdc6d499c5755528a4ce3505929d66a313dc6f329c341c402d0d"
    sha256 cellar: :any, monterey:       "ddc063396bc6f048c60f879b13bb10d12b8ba54e2093e02206e6b246e603fa82"
    sha256 cellar: :any, big_sur:        "f30c78e9f4ec073ed688663ccbb66f2a388bd075d12c2073a2b1946e712e23a6"
    sha256 cellar: :any, catalina:       "c4f2d1d02e6da94dce987ca76315df11153e6a88357de0836b361d0c2cc10f5c"
    sha256               x86_64_linux:   "1c32e471157af08284b5ad0c08f5b3ef9a720d8785c1e7c6022c1a4d44d3abb0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "../c_glib"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
