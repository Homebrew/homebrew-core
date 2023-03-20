class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-11.0.0/apache-arrow-11.0.0.tar.gz"
  sha256 "2dd8f0ea0848a58785628ee3a57675548d509e17213a2f5d72b0d900b43f5430"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "fb4ec3ff6a2ea86d200f1ff613be7821fa3c8966ed17612b72157df449d47a77"
    sha256 cellar: :any, arm64_monterey: "33261051fcbbff940d45b06708f899ca5d94c533fa6d4ad54bde7fade00af9f1"
    sha256 cellar: :any, arm64_big_sur:  "fcd2b68793c79288e456e5f0f592da83aa4d7974d9716a3d5ebfa0fbf5597f08"
    sha256 cellar: :any, ventura:        "07f07b19f4b670a6245f89a88056d472c3a6ca95fbb05a865922a784df6548f8"
    sha256 cellar: :any, monterey:       "93a3e8d9b21702e9fc791fcbd439fb53c27465b101d26f81e0b738c1212c65f7"
    sha256 cellar: :any, big_sur:        "32b900abd74d3dcfa31e799c6b0f97fdffb153e4e685e89ecfa249708c81d478"
    sha256               x86_64_linux:   "59251a6755275ad633ace46f4e32c84bc93c8c335a2cd34476ee1a2544f9c954"
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
