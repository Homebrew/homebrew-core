class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.15/libxmlb-0.3.15.tar.xz"
  sha256 "4cf605965d0e669db737da6443314664ea471807f2719a84550f2490670beea9"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2d692fb9882fdb2423822b8c530c2d62a86e320e7f007b25f823e5ebf1ec377d"
    sha256 cellar: :any, arm64_ventura:  "faf33970ff974eb83dcc34644ae8a9079ac72e2254240713a9c9c1359369de0b"
    sha256 cellar: :any, arm64_monterey: "08590c495e65101622c01ad767374aa185530bf177b0ff8ca3525bd1a1a4923f"
    sha256 cellar: :any, sonoma:         "be18eea4ee81d35ff3e958cecf49322529470bace853f1a1484725a0e96dc1b4"
    sha256 cellar: :any, ventura:        "c20865d695bee54dfabf9f21a569c37fb9ea4ec4281733a8881ef7487df73327"
    sha256 cellar: :any, monterey:       "9f0a96407ce0f4a52496eba2fbe4ab84cc0f776cbac0609d609b6d51e0a9b15b"
    sha256               x86_64_linux:   "f5bdb8192c1fe6e353b13c860aeadca4d4f0d98d317e482c8fae6343709f5a45"
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
