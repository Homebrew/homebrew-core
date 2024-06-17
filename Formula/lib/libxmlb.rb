class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.19/libxmlb-0.3.19.tar.xz"
  sha256 "0a3ec258b12dbf10e5fe840b2421c84137eb7cc1b09c3de6210f3f7d51733733"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b777a7b297501a29a04d2c6329935a82d64ae89dcf090de28c0036a700e94390"
    sha256 cellar: :any, arm64_ventura:  "e3bfe1743a29e3966da4eab2327c871912bda318318b9c6430c7fefbe1f47cdb"
    sha256 cellar: :any, arm64_monterey: "a798d76e1bc87c30496af800eee986d24f03e75e5fbde0e9555756f33ad642f8"
    sha256 cellar: :any, sonoma:         "714df40e63e33e3a92ce69851e8ab7d32968db10545ee63da73b8e4d64a16a75"
    sha256 cellar: :any, ventura:        "dae509b7bd28a60c8e54170f99cfdb6a3e4790b269ca49b9038fd1bd49aee11f"
    sha256 cellar: :any, monterey:       "127f052e1b0e8fb561d0107209e66ac257579797af402d5af7f3965cdf2aaea8"
    sha256               x86_64_linux:   "41146b757dcff6c8f462d6acc6f734a4e3352f70518534fbaa2f97fe28cfe204"
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
