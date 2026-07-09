class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-23/apache-arrow-adbc-23.tar.gz"
  sha256 "c74059448355681bf306008e559238ade40af01658d6a8f230b8da34d9a40de9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "114e7949c37fe58e7ba48fb797f8ecc75ceafd9f6a68f199df982ee987bb5906"
    sha256 cellar: :any, arm64_sequoia: "da7011fde10d91e0c583f2596f98dd15da544534e203d560a61d7bdcdceac0bf"
    sha256 cellar: :any, arm64_sonoma:  "175c34e7b63d63ad1825f7ba17421ff259475c74edd155427d01368c3a1d7fe6"
    sha256 cellar: :any, sonoma:        "e2214e642239a36b6bd352888f9f3dd5d3d20a52ab90c6b5f89d9515c5d7a0c0"
    sha256               arm64_linux:   "bf4c1e3f733868cd3e4732e3273e40d6ce5c9e7212065d6150cf1e9af7f5a9e4"
    sha256               x86_64_linux:  "bd7b6efc716af45d5b6e31c2e83fc7b3e82e9097d7b50d6df3c30cf8892af5f4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow-adbc"
  depends_on "apache-arrow-glib"
  depends_on "glib"

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
