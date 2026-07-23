class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-25.0.0/apache-arrow-25.0.0.tar.gz"
  sha256 "12afc2dc8137bdd4a68876cec939f664c9d55cfc7b75f55b45163ebb4e344d81"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0262693efbc9bd9878fa6d70fc7a3302fd15939035b56ebd1e59d35f4fa0ef72"
    sha256 cellar: :any, arm64_sequoia: "ba8edb84e18958e23051a07e5d52a6d1d5d09aab6dc20b3daccc2b09bdf9a9ef"
    sha256 cellar: :any, arm64_sonoma:  "24de851be81359cbd3de12b1623ee75541afc09cda0985d2731fca8dcb51d88e"
    sha256 cellar: :any, sonoma:        "46003623e630e929bcbd5364c694d8a438ba19d60f89bbe3c43d1aa292ee5bec"
    sha256               arm64_linux:   "4fa6fd33f674c86b098e4b0f0663bd59fefe342a4af775da2e664be47e79c72b"
    sha256               x86_64_linux:  "a8e0575e0c275bb4a98215670c63464df01f03736ac133e1c5304c758da7550a"
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
