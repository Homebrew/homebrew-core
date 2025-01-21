class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.2/libjcat-0.2.2.tar.xz"
  sha256 "f1bed6217234cc2f833d72ae3a375d9164f92a0010b49c5b19b63e88e03de12c"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6068ee9598560adbde442656d0a6cb0c0927d038b50b294d16c387f63da6c894"
    sha256 cellar: :any, arm64_sonoma:  "1e3b85d83f904df428d205a2f6ca41efa79b28cb84fce829a39f5a2d58b6edda"
    sha256 cellar: :any, arm64_ventura: "750a85f098864a3662a2ff1078c883ae12889d7ca462427b3000ce369d18ebc2"
    sha256 cellar: :any, sonoma:        "9773b48acb6954f934260dd05f4e7cc112f1c352002e9d46730bfc71c87bf9a7"
    sha256 cellar: :any, ventura:       "18b0b03903f4ee0d025b82c3b8891d5590b52924f103b78528bf1ad25575fd58"
    sha256               x86_64_linux:  "5fd1a206b91980947c5d16ae3feec17a54454ef54d1ab545d949b0f888de0f3d"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "nettle"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "contrib/generate-version-script.py"
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "contrib/build-certs.py"

    system "meson", "setup", "build",
                    "-Dgpg=false",
                    "-Dman=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"jcat-tool", "-h"
    (testpath/"test.c").write <<~C
      #include <jcat.h>
      int main(int argc, char *argv[]) {
        JcatContext *ctx = jcat_context_new();
        g_assert_nonnull(ctx);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs jcat").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
