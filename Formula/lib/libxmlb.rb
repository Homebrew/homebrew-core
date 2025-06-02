class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.22/libxmlb-0.3.22.tar.xz"
  sha256 "f3c46e85588145a1a86731c77824ec343444265a457647189a43b71941b20fa0"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e0775233be69a811c661f8720b66a4711013ef27e6e36bdd8dff476c9b4c56e7"
    sha256 cellar: :any, arm64_sonoma:  "d3cbbf01b534d2d3c3ed6ec52be13dd2f2e1ba4ef0520f4c27d78cbadb1b3d83"
    sha256 cellar: :any, arm64_ventura: "01a9cef7ad93b5395cc7101a67891d0bd51795408c989b3e84656dc417523930"
    sha256 cellar: :any, sonoma:        "547b825d6d1e54d370c029e9e7b01426ae3837236a860aa73f8720f716c2d312"
    sha256 cellar: :any, ventura:       "5a41d81df13b1f3e95b9c5b0be39638601585891df073c1bf81e76dbe671a8ca"
    sha256               arm64_linux:   "a65b335e5ae108e31a1b65bdf4ef969785f948e46bb1a5c54da501c6608d3574"
    sha256               x86_64_linux:  "b3442cfda49f9ed9d25055f6839fd50fd5c7eb1a8785d20ea70266894548cb05"
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
