class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.18/libxmlb-0.3.18.tar.xz"
  sha256 "552131b3f58520478683ac75fa08fd95cf58db5aa7dac332144bcee5e7780b4f"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8ca5cb23724381ec9b3ffadac1e04eebd738d1f7c33b0b4a9fe940fc844efca5"
    sha256 cellar: :any, arm64_ventura:  "dbfec33159b069baf8ba66a6f95738c7ecffd6ab907800ef2078f79fcf28e1b7"
    sha256 cellar: :any, arm64_monterey: "3e365a7d38fa5f56351dffc3d389f1a642b527e2b93f7102aa24038f55837c25"
    sha256 cellar: :any, sonoma:         "24b0f54d8c68209c5e8c7a30c51aadfaccc747d98c9cdb1ecff4f2bbb126a7c9"
    sha256 cellar: :any, ventura:        "6953aed8d772b4bd03cee9ece64351c14d2ed85c165592572d66b6bdbd986537"
    sha256 cellar: :any, monterey:       "04b1cd991d3ff700c0f000101134374ec16e1e89d80b0429e9bd4850e00f2391"
    sha256               x86_64_linux:   "42e941fcacf3f8d596f305383f80acff88eb3893e7dfe3f47d56ce5bb9f8d291"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang, "src/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/xb-tool", "-h"
    (testpath/"test.c").write <<~EOS
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    xz = Formula["xz"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libxmlb-2
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{xz.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lxmlb
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
