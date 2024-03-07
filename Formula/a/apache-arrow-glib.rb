class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  sha256 "55db63ed9fd6917b7abfe5d4186c9f532cbe48aa53f4040d57e7c29ad70bcefa"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b4d94fdc2c605409a32d52c7fb35e8df71b105f4d67b75eac0888c6087fa5e33"
    sha256 cellar: :any, arm64_ventura:  "2f70b685806d5fbda693c730ff124ecc0426e33e540e1646a8f9bb035bbdb5cc"
    sha256 cellar: :any, arm64_monterey: "319fccd212ae81c6351e46576c563cae7a31918efd0f626e760b5bc4413e67c3"
    sha256 cellar: :any, sonoma:         "5a5165cda5791da5af83c7a65b128dc5e0dbf5c10de08e04a141a7094ef84d8e"
    sha256 cellar: :any, ventura:        "ffa2cf231ee2a184c8b93245ccf0b13c6746348cfbc32c50533a637f13389b91"
    sha256 cellar: :any, monterey:       "6ce37876938e37612521d6d9e70dd85420b3012c11f893f9cb358323a8646fec"
    sha256               x86_64_linux:   "58914e7838f943c203cb60a6b211fb2d6140354167880789c7fdcae0c45fae49"
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
