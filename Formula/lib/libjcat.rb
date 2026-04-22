class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.2.6/libjcat-0.2.6.tar.xz"
  sha256 "d54ad936ceb654e99f59b0227e4d1974b858970d250d98c6484abcfdc8334722"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab8083f80a517a0865a4d87a503a30487a79d64e3d26314be25d9a4a09033488"
    sha256 cellar: :any, arm64_sequoia: "efa10218abe55bd0e6cdc4d51a47abc58cd792bce362e110def947a3db772579"
    sha256 cellar: :any, arm64_sonoma:  "a620a0d5d2ffcb09cc63ece88ebeaad8e090ad3198a2c9e9adb2edabf8c09efb"
    sha256 cellar: :any, sonoma:        "5f1da22c414449a004f2f501c2f846be30e88a571758920051dbd7a49b7c100d"
    sha256               arm64_linux:   "d6424ab2564e8413d402eba7fa9250caa01008751e8b061950581f4702076d77"
    sha256               x86_64_linux:  "dde621af7950e4dafa9a1de473158761b7855b2842a118a41457ef5362eca0b0"
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
