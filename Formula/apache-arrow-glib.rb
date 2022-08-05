class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-9.0.0/apache-arrow-9.0.0.tar.gz"
  sha256 "a9a033f0a3490289998f458680d19579cf07911717ba65afde6cb80070f7a9b5"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2b85faa106edf308595c12af9a62a7f05e100cfaba6b337600ec832dba09aa71"
    sha256 cellar: :any, arm64_big_sur:  "9a1924c7eb7853e71ea0dee8a9e062a657849ae2a25343a37b344c684e8470a3"
    sha256 cellar: :any, monterey:       "15f68c3d3eff600ae62bd362e3dc32ea0e97cfd45155f747fa4a73db1624ba4c"
    sha256 cellar: :any, big_sur:        "92e1eb8ccab434bb9d5234ebf620ef4f26e93984778b9864404ceff06af377f0"
    sha256 cellar: :any, catalina:       "249dff425624bda77f3d26f3f60b3c50a11479e8e11234281b039c4d641535f3"
    sha256               x86_64_linux:   "570d7b532ae126ead199b182cac3eb3de4ccc01fc5b75adf6bd3dd63d8085ca7"
  end

  depends_on "glib-utils" => :build
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
