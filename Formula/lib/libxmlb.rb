class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.25/libxmlb-0.3.25.tar.xz"
  sha256 "77f2768c9debd2e946173cdf9465efd987849805e7c58251c5772ea728a61d9a"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1c3fc7fbdec80b45203671ac8dfe9e8b767675d45e21fd96ff792d43497ee2af"
    sha256 cellar: :any, arm64_sequoia: "9259a1b5f74c09dd8d3fcb6305fbba76c895bab54c4e5efa7e95ba7b64bc2e9e"
    sha256 cellar: :any, arm64_sonoma:  "84645c1edbe9ef27840926efff9eeeb266e5c302cc6659e00526afa642cb7672"
    sha256 cellar: :any, sonoma:        "620e5d76fa5b6ebdd0896e467275cad34770c3bc8d0d3cfdcc52545daf18c956"
    sha256               arm64_linux:   "f50c8cbc1c8334b0815819532be5edcebff9b3fbc2ae4ead656b7ca4f46bacfe"
    sha256               x86_64_linux:  "a47ada3e931a43b22247c160d0f4ea5dd6b8dfc3c0517c458949edc50b126363"
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
