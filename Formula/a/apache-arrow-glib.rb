class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-26.0.1/apache-arrow-26.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-26.0.1/apache-arrow-26.0.1.tar.gz"
  sha256 "1dd1b6701d9de58a4ed82b107539682f46ef6b9e22747e18e03204125c05a987"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0fa11814e476620b7162422677b1d297a5d1a7ff38a46f4b6811a26516aa175f"
    sha256 cellar: :any, arm64_tahoe:       "de4e39599d7e53f3bd384e7374c3afac7a53f0ef97c9e4980938dc9345195a3b"
    sha256 cellar: :any, arm64_sequoia:     "0e00fad1c31493dd3e5077d1c91f9c32fa8c0f40fb834b0e9fa0c83346c47cc8"
    sha256 cellar: :any, arm64_linux:       "fffeb225b17f3e5493e1f06056f70c9567b63333b61598699db19bd62525f3e3"
    sha256 cellar: :any, x86_64_linux:      "b552037c1a46f94ff9bb46d6b76ac845345f47cf06e59d9bf46affc691ab518b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "apache-arrow"
  depends_on "glib"

  deny_network_access!

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
