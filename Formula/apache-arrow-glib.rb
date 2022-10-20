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
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "5702ea88f6d06deb2a94d3ef4bfe96dd601d6feefa4873b18f9b61de5cca2dc7"
    sha256 cellar: :any, arm64_big_sur:  "d4e00b5048cf5c8b57e653999e2154dc8241102409b1ad610c34b37f0918cd40"
    sha256 cellar: :any, monterey:       "44e902f6ddb69ddd3ee6faf81d022ef46a70fdf2e0dbecd161edc7922d1eb998"
    sha256 cellar: :any, big_sur:        "7f4d015a711efc23e3992405b783b0ed197045a61b5764e8bf319c09952f5753"
    sha256 cellar: :any, catalina:       "0cfe7a106098c5c5de3bfa99aab74404f5f0dc8148d387fd9894947f6ffa4f8c"
    sha256               x86_64_linux:   "196fd7888d6047801a2bfc954de80e8648c5b833f9b1d109dc35c4dee072e501"
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
