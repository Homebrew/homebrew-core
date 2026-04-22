class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-23.0.1/apache-arrow-23.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-23.0.1/apache-arrow-23.0.1.tar.gz"
  sha256 "bd09adb4feac11fe49d1604f296618866702be610c86e2d513b561d877de6b18"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24553932397543b3d41feebb2fa20c8d559ddcadf6e3f06c6ff779975372a821"
    sha256 cellar: :any, arm64_sequoia: "b994f13b97fbd98404c610cb55309db467f0ab945494f4dfcd4cc3ba18bc7979"
    sha256 cellar: :any, arm64_sonoma:  "fa4d5c0c81ebe2cc1c4ce81eae1925d1970c387750c1caec3cdb06e65dd28580"
    sha256 cellar: :any, sonoma:        "86ad2fa2782c4882f9c00ff72baa65b62860071112085f9b9484291eb06f167a"
    sha256               arm64_linux:   "cbe8b75ac2f2bcaa5fb4da3ec5d04e67f4792dba890d93bdeb9db4524d844caa"
    sha256               x86_64_linux:  "a3e637fb77960c7cbd20190a3c5aa65ec646d275b6dc9c56836114f7fb943143"
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
