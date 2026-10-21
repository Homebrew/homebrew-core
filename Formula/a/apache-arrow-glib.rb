class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-26.0.0/apache-arrow-26.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-26.0.0/apache-arrow-26.0.0.tar.gz"
  sha256 "b153ef472dd89ef4cb84867ca238f2a3a9347d8f4a78913d16ca2201606f0425"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "99f6aa8952dcf0135cb0d4bab2fe6236364c3dd15e14b7aabcd6e81200fb65b4"
    sha256 cellar: :any, arm64_tahoe:       "7624542740086c2ab50a637be684d2b38a6691fa101aa3a1ab22d96eda2738b0"
    sha256 cellar: :any, arm64_sequoia:     "4834d6f1e992c190cd419e985042b2c8afafd80ddcdd962a4767966ef33a85af"
    sha256 cellar: :any, arm64_linux:       "d66a65af7658d0808a0ef344dd23cabd73dd7b2680d1252c7ef34fabc78532fe"
    sha256 cellar: :any, x86_64_linux:      "66aa2f5b7d2f6257e861ce93a7c2b2cf8a9d212f94bf1aba48d5280b6fe9186c"
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
