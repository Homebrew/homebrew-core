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
    sha256 cellar: :any, arm64_monterey: "d5ca4c03e21608573570d28055ff7dba54ff16237c4e2e85953f85ab2b297400"
    sha256 cellar: :any, arm64_big_sur:  "6a21e83c704d9734adafc7cbb4087ae6f0389c3cc537d0598fae0ec186cfcd4e"
    sha256 cellar: :any, monterey:       "014cc1483619a6a4686d0e8a73fbd618ee41fb3a16e5e969d598af7c4ff28744"
    sha256 cellar: :any, big_sur:        "7e407ababc447ecdcba628a18f6d1d974172db8fadb9fb1784196f023e50eb72"
    sha256 cellar: :any, catalina:       "1c04df7e3fb2431974ecc8dbf3231611be54ca76799abe2d505bc807a8291555"
    sha256               x86_64_linux:   "d049b74d0292bb4c61e40f353c4ca6e5a465e47e3a06d60a979eeccd355ca652"
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
