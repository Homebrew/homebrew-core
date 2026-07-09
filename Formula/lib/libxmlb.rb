class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.28/libxmlb-0.3.28.tar.xz"
  sha256 "5982b4fe344deb36e57b40d7582f594ecd9414f86fb8258bb56f8b1a38e1d527"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f3d28fa056e9fa2df2455a72ae011b74ce1c2fcb7f841e084b3ad97a730f43ea"
    sha256 cellar: :any, arm64_sequoia: "fddc011dc4cf60677ab142a0dcd53ab3c1bb8a0a7893fe2295796e456a8f5a78"
    sha256 cellar: :any, arm64_sonoma:  "11bdccb38316f4a04c2bbbe5e883e889c842e09a537f5cd8510da7c12cdcf676"
    sha256 cellar: :any, sonoma:        "d55a0f0cfcac073dd2092fe90a38e95f2d62405c3027e3e60ac1d9b445af267b"
    sha256               arm64_linux:   "1e132bf57d99c58ef9a80ea3222f9fda51effc0dae735c820843a23f28ab3e3b"
    sha256               x86_64_linux:  "1c5f603dc5b8c08b3b6389319e5900f4db0be2b2bd97799150499a0a1d6e318a"
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
