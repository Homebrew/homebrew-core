class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-19.0.1/apache-arrow-19.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-19.0.1/apache-arrow-19.0.1.tar.gz"
  sha256 "acb76266e8b0c2fbb7eb15d542fbb462a73b3fd1e32b80fad6c2fafd95a51160"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8358dd7648c6dd2077b0a38a705fc66100d9f73f76df365b32d20fa2895cd8ad"
    sha256 cellar: :any, arm64_sonoma:  "552a212f5b31f7148b84b9b7d608fea7aa81169959f414a908eaab14aeddbf10"
    sha256 cellar: :any, arm64_ventura: "c14735c1e5bf66ad3cdbefd5eb0d94529c4e1525684c6bb59a56b6bd9c73e928"
    sha256 cellar: :any, sonoma:        "c8b1852c876c2b0ebd49d70f29e2ece594d3b9e6987a7b20969114b7cb8663ee"
    sha256 cellar: :any, ventura:       "543ca4c13245ec92239a913bab4ebfba44d3e0c8069db9773801ddda6ceb8d42"
    sha256               arm64_linux:   "1366efe6189e58917cc6e1afe1eb67d4e66a55658b841bc5ed3db873daca8201"
    sha256               x86_64_linux:  "4582ac91ab357cd8bed148c3293eb85be84fcc24d867a1f43b1f1531a5188444"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs arrow-glib gobject-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
