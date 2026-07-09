class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-24.0.0/apache-arrow-24.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-24.0.0/apache-arrow-24.0.0.tar.gz"
  sha256 "9a8094d24fa33b90c672ab77fdda253f29300c8b0dd3f0b8e55a29dbd98b82c9"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ce0ccbd90c4932566c554b2d73f67849bd41cfab3298f128fb38200b6b1d7c3"
    sha256 cellar: :any, arm64_sequoia: "751c1d8a5b9d90f934c6482bcb9bd0d147b78a33382ed692634e77393076a02a"
    sha256 cellar: :any, arm64_sonoma:  "16aac4a0f49e7a833bf049716a0ad4a908d897923b4bc0393f354e6a0f1ab4a1"
    sha256 cellar: :any, sonoma:        "b33267375877e2c50ce36a609ebdc3b8c57cabae8691ca15e0c86a8dc322334a"
    sha256               arm64_linux:   "dee72a183a6d3dc83fa34d42560b67fe6d852900d0d2470206d93a54bbc486dc"
    sha256               x86_64_linux:  "907fc29971200633828bfa7c774f78ebc0eb6b8f839e305a4417a144d4582536"
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
