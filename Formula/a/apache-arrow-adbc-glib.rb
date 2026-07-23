class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-23/apache-arrow-adbc-23.tar.gz"
  sha256 "c74059448355681bf306008e559238ade40af01658d6a8f230b8da34d9a40de9"
  license "Apache-2.0"
  revision 2
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61cfa19f485544948ba98b615a101d5ddc92692301e1e034d360cf0dcefe176e"
    sha256 cellar: :any, arm64_sequoia: "01b446568a8db13ecbe7aa5c7e333b8acce2fcd19f515ac3e2d4b61781128b3d"
    sha256 cellar: :any, arm64_sonoma:  "b1913fa4a60904ad9c5e55ae8f08c753cf9318e3a3a06207ac9f5fe68d76067d"
    sha256 cellar: :any, sonoma:        "94b155ceefe5405a7bea0ff7dc3e0be67aee302a9fb54c91620597c5c10d9b65"
    sha256               arm64_linux:   "31a823b62f4ae32ec5834a1509c58c3c55e821773e4ffaa875372649c48a60e0"
    sha256               x86_64_linux:  "488fd70e3b5a8645b7d175ec0adc8a7fa0ee58f7d0f090b340572fbcd3bb9538"
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
