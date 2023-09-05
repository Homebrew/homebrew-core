class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-13.0.0/apache-arrow-13.0.0.tar.gz"
  sha256 "35dfda191262a756be934eef8afee8d09762cad25021daa626eb249e251ac9e6"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b9f75b8343e7f9bbb76382096ee6bb8f847218c561d9f7f44f342c1519de5bb1"
    sha256 cellar: :any, arm64_monterey: "1ee3692b3f2e46d5f7aece97e38483777d59750d44a9e54d018b2fe91d326f2b"
    sha256 cellar: :any, arm64_big_sur:  "47567d2796405f39f29c0ce3492c2a71779f48ed982bea1dd820d58fe475a33b"
    sha256 cellar: :any, ventura:        "4bb9d5df49ed639ddc696660b8eb8634a18b56b22eb298b09c331057a5c93a49"
    sha256 cellar: :any, monterey:       "231a5aa831947d2f57bf0096151477b284c314541fb4d8caa5db70ed375e3da3"
    sha256 cellar: :any, big_sur:        "800e91e010c911bca73f50e3c752e13fc3ae09bbbabbb6495fb25e427324aa33"
    sha256               x86_64_linux:   "95a1221d426d2329e6b4526ee134eb6112a19f6d8f842303e67a9a990abfef94"
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
