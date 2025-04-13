class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.3/libjcat-0.2.3.tar.xz"
  sha256 "f2f115aad8a8f16b8dde1ed55de7abacb91d0878539aa29b2b60854b499db639"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f81dac6097133f01ba6dc2890ea638bc19157b5532262f651523c5daf3a36ade"
    sha256 cellar: :any, arm64_sonoma:  "008c768443345295eb167faf45cdca4cca66450522e430c1b5754335488f5a30"
    sha256 cellar: :any, arm64_ventura: "40b6538beb4dcfc8a8eacffe717dccd84595284b564c43c4da4828f7683d1dc4"
    sha256 cellar: :any, sonoma:        "e531fcf0517371bd203e66ac885f2a89b5f0f1e184d02e2c4949a3a2d92a644f"
    sha256 cellar: :any, ventura:       "927a664154de77bcedf12dbb4f9232851ef9cc811b3b80308f9ccaca88d1d5b4"
    sha256               arm64_linux:   "88a16575b027306459c033e2d982e34f1c0d22fb2f368482ede91f36a930dd01"
    sha256               x86_64_linux:  "1d5b42e6de499edbb2107b66428da6be5d1695e7dd61b4cb5bc937f597e9ada9"
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
