class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-24/apache-arrow-adbc-24.tar.gz"
  sha256 "2b4b420937f62f7ae56f46dbd6951a5e4ef0da43158080a58cb44cdd09a8b2e0"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  livecheck do
    formula "apache-arrow-adbc"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61b389226df57f0bd4fed36fda4c1041ba486bebfaca084a54c4a7c30c4bd14b"
    sha256 cellar: :any, arm64_tahoe:       "339b3a995e147a70ce1daf5e05b2e5e31e4e7c24ecf65cdd32a5b2ce7fed45dd"
    sha256 cellar: :any, arm64_sequoia:     "91688e496c5786c2dfddd828198ce0f9d1538403343b3c051d718f954fc8bb80"
    sha256 cellar: :any, arm64_linux:       "8b683bccd76895a847b58ea9fbaae770e12bd5d7bca9a5500c086cd2447686a3"
    sha256 cellar: :any, x86_64_linux:      "e4fcf47fbf2c2bf36a8d08e931163a9797cc7dce53b8f7a3a1b6fedf80695c7a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow-adbc"
  depends_on "apache-arrow-glib"
  depends_on "glib"

  deny_network_access!

  def install
    system "meson", "setup", "build", "glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <adbc-glib/adbc-glib.h>
      int main(void) {
        GError *error = NULL;
        GADBCDatabase *database = gadbc_database_new(&error);
        if (database) {
          g_object_unref(database);
        }
        return error ? 1 : 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs adbc-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
