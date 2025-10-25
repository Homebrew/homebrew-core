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
    sha256 cellar: :any, arm64_tahoe:   "1ae66ca7d006705b24abb76a80126c8aa6bd08fe0bb06ccdb809aa07477ff83a"
    sha256 cellar: :any, arm64_sequoia: "5f004095e9a67918ee7c1cfde17bf071d4a79caf3e27b5cac09ac1e6c03b5c77"
    sha256 cellar: :any, arm64_sonoma:  "44999e5b2a9658c20b288e9a3af01df921e8a7d8eb7d36cafb558dfad3da71af"
    sha256 cellar: :any, arm64_ventura: "6b14ecf4d7d980bd1e47160236fc827fd586825892ef54f1ce833185d7652618"
    sha256 cellar: :any, sonoma:        "bebd307d4033aa01b91f4e8f2ef555399fdf3879473578ac43fa5d82727844c8"
    sha256 cellar: :any, ventura:       "1450c1222d39a1aec318819dae8d30afd958c9e4ad39fdd450ef46a0827ad6a1"
    sha256               arm64_linux:   "025eced98b83562c6e92d48434a81645aaae4d06ae63a29a79b5e5993687fc73"
    sha256               x86_64_linux:  "c51e0a090a554bb95ade46e3dfb48f06a502541d87259a8f6cf6579bfc60c991"
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
