class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.4/libjcat-0.2.4.tar.xz"
  sha256 "caabf7c2d69493d1fa61982ff6556024cd20440643c2d522f146560ed1d700e3"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "34acd692b18099dd4f68a4b793c8dec3b4ac4b23b1e1d41f420d56861f602b17"
    sha256 cellar: :any, arm64_sequoia: "d84f7b92486d855a7024d171ce30c61406018c156434be896ceeafe8194f83ff"
    sha256 cellar: :any, arm64_sonoma:  "a9f7e4a0936acf3a97dfb9210cb3f23bf71c1e074ca15c42c1c0b376bac5ae28"
    sha256 cellar: :any, sonoma:        "cd00151986797d54cdf5be5c73bb15c61fc27d55c4a2265e54542192ac588901"
    sha256               arm64_linux:   "ff2b545414a05b970edb915301ff287df1a874244440c333e0a6586f0377de9b"
    sha256               x86_64_linux:  "82b6710bdd67960c45d7e7909f9672dbd017b064db4621d927bb35a3f6895999"
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
