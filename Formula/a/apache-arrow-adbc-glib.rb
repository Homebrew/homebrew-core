class ApacheArrowAdbcGlib < Formula
  desc "GLib bindings for Apache Arrow ADBC"
  homepage "https://arrow.apache.org/adbc"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/apache-arrow-adbc-23/apache-arrow-adbc-23.tar.gz"
  sha256 "c74059448355681bf306008e559238ade40af01658d6a8f230b8da34d9a40de9"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-adbc.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0e0a6425089f9ce5a55e341a62a128c87874e7a4fa99dc346b6bb73bd68a004"
    sha256 cellar: :any, arm64_sequoia: "c0fa4af6ea213d65d62e6874533f102671a1d3547b82bdba3c04d22346cf4058"
    sha256 cellar: :any, arm64_sonoma:  "5335d0bc8fd54bfe1235bf261a1b7c55cefe86975eed17e7c9fb59bf69635af3"
    sha256 cellar: :any, sonoma:        "9d749ee6fb5525e738f894436155ef545dc4ee9b640bf01e6dfdbad63c37c772"
    sha256               arm64_linux:   "b516a992eecf401b8427f66864730339611baf15b0d8df6ffd0170eafe86cdbf"
    sha256               x86_64_linux:  "2d6ec8b6a9c9f78e78b949b7ca045bb0f92da608e56d051b0647c09d040303f6"
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
