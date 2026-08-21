class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-24/apache-arrow-adbc-24.tar.gz"
  sha256 "2b4b420937f62f7ae56f46dbd6951a5e4ef0da43158080a58cb44cdd09a8b2e0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  livecheck do
    formula "apache-arrow-adbc"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebf8cbb9f09b50648c862485614c1cc7246f9fa52160e6313de72f26a544780e"
    sha256 cellar: :any, arm64_sequoia: "42ab2cba36d98d42217d1f36f45077f845cfb679dae5df10cd429c686ee401fe"
    sha256 cellar: :any, arm64_sonoma:  "db0d6e08d916b403fb14bb4cc9e179e1b2fd0235863f0a891b3578ad7cea9c96"
    sha256 cellar: :any, sonoma:        "f03bf66a491f26b09091b00d3467757d61c3aa0008480658daa2acf99dd58e0c"
    sha256               arm64_linux:   "6e3b697f7b04a341babea669604bbb025d36c4d7a81af7b1be72b3a0da67da9b"
    sha256               x86_64_linux:  "fa5ecd0e58c97fc3b45f24c4072fdf609791746fadc56cd56874219a57bb78e3"
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
