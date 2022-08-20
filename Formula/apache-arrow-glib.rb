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
    sha256 cellar: :any, arm64_monterey: "78ec02f03f475726bd1458a4e3d417f8b83013f6188257c984a3fb9233d2b3d4"
    sha256 cellar: :any, arm64_big_sur:  "e4b50a47ce255e90b02edc94dd933ea7e9df3311266b9bc68d6c5b09ef28f6c1"
    sha256 cellar: :any, monterey:       "d8e6b958b5e6a59b6a0197a5d68381227787693b4a12e858c5bdcb8ea7bc67af"
    sha256 cellar: :any, big_sur:        "dcb4f474faedf9602169413f71b221cc7d09214401c3be0b733eb2bc6b5f007b"
    sha256 cellar: :any, catalina:       "9527e1b179e602bc219cce2efe8efcccbd8c23b6947bd86da7d5a86ba610b3b8"
    sha256               x86_64_linux:   "026467ba89eec611a67fee7d92292c69caf9d3cb8eadf85ca40c0c92e8b588fc"
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
