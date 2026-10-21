class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.29/libxmlb-0.3.29.tar.xz"
  sha256 "448294be33bfae62f00fa66e506f1cae80237ce71b7ab6530aefa75005eeb08a"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bee744ed5228c334fecedfab294d3b511d94bb4f49451e2425a73b8073987c9d"
    sha256 cellar: :any, arm64_tahoe:       "af9f57864d1e2a2dfde2a9c110e722edd97a4156fa981ddd57e4296201659d69"
    sha256 cellar: :any, arm64_sequoia:     "854f351ce57f8242c8ab2378a3f41827b38dfb5f9c18d143c445a8847aa06cbf"
    sha256 cellar: :any, arm64_linux:       "73692f36135bf7e666b3216a2c9daef7c36366757f0751e6d9cf2bc724ec6c27"
    sha256 cellar: :any, x86_64_linux:      "5af2a76a6dd8cd6fa93d17cec28dcc6274f44c2b414975b8518916604918cb11"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "src/generate-version-script.py"

    system "meson", "setup", "build", "-Dgtkdoc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"xb-tool", "-h"

    (testpath/"test.c").write <<~C
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs xmlb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
