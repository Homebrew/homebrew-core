class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-25/apache-arrow-adbc-25.tar.gz"
  sha256 "de2910f951eeb3c57d882e621a32d133580cc6b0ad01ac25056f4ac709b8b2c0"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  livecheck do
    formula "apache-arrow-adbc"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fdc7e4a6a2e4e5c3187670fb2ae110163149cf8efbcf791bd5f3fd20d7c3ecf7"
    sha256 cellar: :any, arm64_tahoe:       "3f6a7b829577c7f5a814971190bad4dbf806c4bb38ac9f007ae3134f06de0fe0"
    sha256 cellar: :any, arm64_sequoia:     "35f137b7227b159b726828a56f517fd722a23075dd2404086677b7f1e3d58b59"
    sha256 cellar: :any, arm64_linux:       "acd88f4875d03bf090a232e0b489e6110d0e0520bc4a8d676cfc1f1068dc8c81"
    sha256 cellar: :any, x86_64_linux:      "9d47877852c9a603cc0bcaa8b8459da9c5571fbea9ac6980f601d159cdb76a02"
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
