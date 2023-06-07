class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.0/apache-arrow-12.0.0.tar.gz"
  sha256 "ddd8347882775e53af7d0965a1902b7d8fcd0a030fd14f783d4f85e821352d52"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4121a728b70540a2047f4d081aa56bd2195c21e9ed6f97f3de9647c4b2c030ee"
    sha256 cellar: :any, arm64_monterey: "efb013b1c97156f6a9631ea5b588c80915cdd9d3a54835363e49714d560b1671"
    sha256 cellar: :any, arm64_big_sur:  "4567dd09c781014602bb95a245b489f2e8e4464f1199e3f5e79f07ae5795cbff"
    sha256 cellar: :any, ventura:        "2661ee45379086c83e807db22b2c40e4a749a1687bed56ac74f9bb090297ec0d"
    sha256 cellar: :any, monterey:       "774c2527ca724f6cd33cd8d92acf43e5349b04366e99a36af02a869f0f5f5914"
    sha256 cellar: :any, big_sur:        "9878a666fb3454fb7edef21a9e99c5392fd1c3e722b5d06d50538bf51bfd81a2"
    sha256               x86_64_linux:   "e223d3f112867975e8284f0ff61ce947b5058ad0ab07cc8ce8e4aabad69237c0"
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
