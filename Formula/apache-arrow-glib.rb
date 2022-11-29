class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-10.0.1/apache-arrow-10.0.1.tar.gz"
  sha256 "c814e0670112a22c1a6ec03ab420a52ae236a9a42e9e438c3cbd37f37e658fb3"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "32a3e16a0b4c31bdde63578f6aefbec8321136170fbb06aa33555e75d05c2944"
    sha256 cellar: :any, arm64_monterey: "2442b79d3ad5bc99bdc236d3127246d634f3ee2bd5d9296683e1971e02dc3a09"
    sha256 cellar: :any, arm64_big_sur:  "98f46404207b503ee006148039a2bf9b3d61241fdaed8cfe5c83c4150a164975"
    sha256 cellar: :any, ventura:        "229109fcd848b355250a9f91a7d291151babadb95d48b6519ec235250e10e11f"
    sha256 cellar: :any, monterey:       "e1ba0b790ac8053bbfe583a25c2d268b75833c5b34b035ebccb5da58085eb8d5"
    sha256 cellar: :any, big_sur:        "10412170b194e02e67c7a5d989cf6a608d4f914419d4d5b8b01675b935297542"
    sha256 cellar: :any, catalina:       "af2c6353228d403a1d10bc41cdea77c4f738895385e8078cf0b06da9b187bd7d"
    sha256               x86_64_linux:   "30b2626abbf7e65899bb786edb98aeb454f64e302c3b9cf119e624e88f408a39"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

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
