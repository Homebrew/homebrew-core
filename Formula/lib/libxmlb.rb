class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.14/libxmlb-0.3.14.tar.xz"
  sha256 "a2f0056eed14ff791aee2b08b1514a0f1b6cf215f0579138a8cae8c45a0d3b0f"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d559affb136b4760ff305c43a5e44e5718825d288c51e6cdecd0010f714bec6d"
    sha256 cellar: :any, arm64_monterey: "9d9c5f63e7b4954af974a934a25f336b21414c03f5c211760f60129b9fdb6535"
    sha256 cellar: :any, arm64_big_sur:  "f3e90937bc23a93fdabed8a57a3730bc493c8d4b7f11c596b3866f0fe8af3fb4"
    sha256 cellar: :any, ventura:        "32f59c353bd95d2adfe0f211bb72ab4151ab6036a2903505526fc0235bb8f1da"
    sha256 cellar: :any, monterey:       "a8bd5a4736840b4101c025e9a1f388fcecc59b5b38bd8dc7d190fc85b518b98e"
    sha256 cellar: :any, big_sur:        "90c78e6761f8205aee5e6cc17f84df1242dd39e9e40ab1b7ff31c6377f59fcab"
    sha256               x86_64_linux:   "2edcfafa3520e595284fe6c23536e7761a49465e55b7b00de444da193ea7ab25"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
