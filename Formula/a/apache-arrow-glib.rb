class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-19.0.0/apache-arrow-19.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-19.0.0/apache-arrow-19.0.0.tar.gz"
  sha256 "f89b93f39954740f7184735ff1e1d3b5be2640396febc872c4955274a011f56b"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e420ce8d7c772054c9040a326f54be83306741c3b13f1f95c1aa660bcc3419bc"
    sha256 cellar: :any, arm64_sonoma:  "f7f697c4bb8922d0fd7ebea9fdedcb03798bb3ce641525bd5b5def7e30d9dbe4"
    sha256 cellar: :any, arm64_ventura: "90c37373807d0607465aeb66dfa6a8f4e1073a1c609ac3d3968234f2f63b12ef"
    sha256 cellar: :any, sonoma:        "2f66ab77233cfaebd4a6cb35ee75a33b6533973ee25608c88a6a4e0f074762c7"
    sha256 cellar: :any, ventura:       "8339abe968a0697213167673c40071a958f1eb636f02da0ce33e4f61d3a8de2a"
    sha256               x86_64_linux:  "6776b45d6bafd3bdc32f1d6d0be57e7ed60b8bf0171e87c5931ad76a176a2191"
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
