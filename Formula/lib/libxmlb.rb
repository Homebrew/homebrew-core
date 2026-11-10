class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.30/libxmlb-0.3.30.tar.xz"
  sha256 "2cb894b873aac5fc9e9b6228d4e795f7236d16e429ed2de8f95179a131be3a68"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "173ffe8a5811ca458180b310e47d9b4e64735d4368d55160d100015648304c05"
    sha256 cellar: :any, arm64_tahoe:       "46ee8c6feea335867472b2b7c9031ea7bce340fcf84cd308e081dc02c15bad49"
    sha256 cellar: :any, arm64_sequoia:     "169787720f5f4f63bb19f6cfa8b307c0cf126b8b651b4d8a58ed642ee4c27884"
    sha256 cellar: :any, arm64_linux:       "e224c540d4fae63704b91c96decfa3fbd4cf61777a0d5cb9acb38e0ad2fbe95d"
    sha256 cellar: :any, x86_64_linux:      "838fd4d5d09e1a732a00d1dc2f76e46ef197054ba3f0c7d6b492151f424990dc"
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
