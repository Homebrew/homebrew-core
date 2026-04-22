class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.26/libxmlb-0.3.26.tar.xz"
  sha256 "a18bc447fff0dd0d76a2e6cd4a603b4712047c027f9bbbdc31ebc25f0e2c1ed9"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "26444295fa3f0a3196a3cefc81945ac38f4eb634b252ae6661b6a93b92f6492b"
    sha256 cellar: :any, arm64_sequoia: "64c06b5b51bfb1edc51bd187736a17a90587282417c2d3a0f4acb5a0ff9d4c61"
    sha256 cellar: :any, arm64_sonoma:  "fdfa2c4def3009afd053fa4bc7f0a1f00853dd1367e8d90a00b7b93a269e857f"
    sha256 cellar: :any, sonoma:        "6aa91c24dd6da83c7c91e00268deba06ab25c5bc208274b7e4930aac4a418378"
    sha256               arm64_linux:   "2ee39e243e70aa3588593869cc2b1b63837d990ee9ed942c833940e42ad16006"
    sha256               x86_64_linux:  "bb55d875f9cc32023299161dae441cd2919fd732ca91172453fc0f307de80be4"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

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
