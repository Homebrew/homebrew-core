class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.21/libxmlb-0.3.21.tar.xz"
  sha256 "642343c9b3eca5c234ef83d3d5f6307c78d024f2545f3cc2fa252c9e14e4efd1"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "7602ee280a7157ea41ff0ee62d720523b320ddf104dc788ca466587639b39953"
    sha256 cellar: :any, arm64_sonoma:  "6e72c476724d651c02926c05e26219ed4e4cfdceb28ad0def3ccba646928e1de"
    sha256 cellar: :any, arm64_ventura: "a97159b6525f962e97b4584aa7bab1adeaaea2f917738ddc279da7ff804a566d"
    sha256 cellar: :any, sonoma:        "239946259891a14150b7e690717f39f2fddd77e546cfd80edbda4c2a58250f43"
    sha256 cellar: :any, ventura:       "b6363ecabc2c73f0916a5510d7f65ac8bd4f35200e67dfb15412d221ed500cc6"
    sha256               x86_64_linux:  "f9928bd831f1c92e46d44e527f295065325c48ca07a096b2655c53275527d70c"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
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
