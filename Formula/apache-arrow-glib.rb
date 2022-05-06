class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-8.0.0/apache-arrow-8.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-8.0.0/apache-arrow-8.0.0.tar.gz"
  sha256 "ad9a05705117c989c116bae9ac70492fe015050e1b80fb0e38fde4b5d863aaa3"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e438325ad136f2ec4c35b5eddae9d5f78ef7db4bc8279e9e2880b7c0be54e511"
    sha256 cellar: :any, arm64_big_sur:  "79eb12dbb0cf6932b9b7627ae00e2d75304971c0cb5ec7420e166fff0ecd245c"
    sha256 cellar: :any, monterey:       "4ba7e21beee9e4a9eb29e5b9d61c7b3d06739f3b0dd45c8967220e73970b2623"
    sha256 cellar: :any, big_sur:        "91057ccc8eb248c595ce9ec221d90ca4c46db28a2c068dead4192c4451b8a662"
    sha256 cellar: :any, catalina:       "5e015621c9c21feca52d6785cb9dcc4ac306987104cdc5c240ef7d3ceb82ce70"
    sha256               x86_64_linux:   "e9dc9438301d14b07323407cc7c25bb60f992084dba8ad543a892ffb544cbc95"
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
