class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.2/apache-arrow-14.0.2.tar.gz"
  sha256 "1304dedb41896008b89fe0738c71a95d9b81752efc77fa70f264cb1da15d9bc2"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "72ed04737f168cdacd815ae21299e6a724fc34c599e542bafe76b07793784376"
    sha256 cellar: :any, arm64_ventura:  "33b856ac4805ce35bfa95597f5800a0c47dda37e892cce420619543d88722563"
    sha256 cellar: :any, arm64_monterey: "f43f4a6a0be77888bc92fabfd2b06ff810cc1cde10e80f766c4446b5b3464a5b"
    sha256 cellar: :any, sonoma:         "3f39949e2c4ec2b3d4f15ddef5c2e61372f91476149b8c964fcdff8ad36dc528"
    sha256 cellar: :any, ventura:        "21807f0037c2c98c1067674bc8818fc42e0cd19008132b0531cbc0717a1f44a8"
    sha256 cellar: :any, monterey:       "b5a5f6fde8c910fe92cfa33d79b34534958f967a3456deea2694745331756bee"
    sha256               x86_64_linux:   "6c1c3e55db4aadc3d355ef7d79cc4cc9cd0431c88d0f2c916123adf16587e7fa"
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
