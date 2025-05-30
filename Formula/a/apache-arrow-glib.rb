class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-20.0.0/apache-arrow-20.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-20.0.0/apache-arrow-20.0.0.tar.gz"
  sha256 "89efbbf852f5a1f79e9c99ab4c217e2eb7f991837c005cba2d4a2fbd35fad212"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8294049b1709df4be53384fdafbec4e87a2a6ddc118a9f3e2867c67efcc9b02a"
    sha256 cellar: :any, arm64_sonoma:  "ccde01a3671cac00aab2015fed3e35a5b74ebcd270c79e994fa48955dc08eb73"
    sha256 cellar: :any, arm64_ventura: "df19557f102ca5b5e91b31ee6b5b7a33dbcbd15ced6cd3652864e85fc6359621"
    sha256 cellar: :any, sonoma:        "a7cb4dc9dfbe8a3246661f1f754d4dc4c84b665ee8e6313683bfbf63ce784492"
    sha256 cellar: :any, ventura:       "1f6cdbbbad28c17ad4b496568364cd787bcd3c0956ede80435837f370485b946"
    sha256               arm64_linux:   "b3750439d49985c88717279650068e5b278b8f0e2973f993d176a342d5692d3b"
    sha256               x86_64_linux:  "23c52e3e3e12a375416a6920e8983856b8a00dd4ff0ab7f4a5c6c8f2899bc068"
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
