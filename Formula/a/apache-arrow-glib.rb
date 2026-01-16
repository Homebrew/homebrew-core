class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-22.0.0/apache-arrow-22.0.0.tar.gz"
  sha256 "131250cd24dec0cddde04e2ad8c9e2bc43edc5e84203a81cf71cf1a33a6e7e0f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9765a85472ed5a33700b5a3d061325f72ac7dc4850b50042a394336b6b1dba84"
    sha256 cellar: :any, arm64_sequoia: "c5316e801f0056c6815d788ca56f849bba8407e7ca0f470acb62ea5e02251099"
    sha256 cellar: :any, arm64_sonoma:  "9a27bb01bea4eff3ba54686c4823f2bd5cfd23141d4b83036283a6ebdf2f85ca"
    sha256 cellar: :any, sonoma:        "073ee02f17e0dfa3354b9ca2afcbc6c513dc64cbe5b0102dfa8ee6644eb9ae90"
    sha256               arm64_linux:   "85325a5a705ff4f8c8ecb0b4cc9d258bb59e44e3ce016ed457a3ffbb8fa1c906"
    sha256               x86_64_linux:  "603df6e1fbab7c16077726f67da6768af06ffb9a2e4540eb91f9a323ad633697"
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
