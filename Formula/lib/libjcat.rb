class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.5/libjcat-0.2.5.tar.xz"
  sha256 "066e402168c51bffddcf325190e5901402b266fbda2a4eed772fd06a88b941bf"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0baedc0d4357dc676085ec9449b47d4c7bc06c814c18fe11f21f4572e553b8bc"
    sha256 cellar: :any, arm64_sequoia: "c0ccdadfaf63911bef5e8a40e337c42363e9dfd3fed2c2eff503e22e21f18a66"
    sha256 cellar: :any, arm64_sonoma:  "7d437090bddf553740535577b241e38a24c16bb9aaad53bcd001f2d0cfac28d3"
    sha256 cellar: :any, sonoma:        "70104120fd7cb51fe52f6ed5adca2e7be13054365e3e50f9a477e9bdaa3a6131"
    sha256               arm64_linux:   "590462d8ddf82053ddf556eb2e543148da9451602a2c390d95d32b635040cbb5"
    sha256               x86_64_linux:  "43b49473aa79a0759f80a68e8f7a16385a9ea8d0af6a52ef49fbb108f3aac975"
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
