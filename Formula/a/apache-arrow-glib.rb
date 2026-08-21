class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
  sha256 "43d5de0a581f43cf63a2c06b4dcf13b9ff6fcd800f023324596e5781093bc500"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d87ac6a7b86293def6f238a633489911177d9bf50fbe566fb0a0b2d9d7950302"
    sha256 cellar: :any, arm64_sequoia: "5db3a4f6f8ff8abd5cb41c3698c51b26720215e6899b0762bbdab6f9ea8f3ce2"
    sha256 cellar: :any, arm64_sonoma:  "b40656d4e5f0054f3fe74406c859618f6200c56f0b49aa939500c7c06a8c5018"
    sha256 cellar: :any, sonoma:        "53ce1b8baa6f8534c71215be7a2eae54cf2240e714c338a4942ddaf06533ef54"
    sha256               arm64_linux:   "a8110728dcb0c16b476ad967984cd35b854c1481fb9b0c9adeff46f0c8adf5cb"
    sha256               x86_64_linux:  "e710080356702fc4a20885ad5fa7beb30e2bc629a85b9fca58e374d5ff65b04b"
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
