class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.19/libxmlb-0.3.19.tar.xz"
  sha256 "0a3ec258b12dbf10e5fe840b2421c84137eb7cc1b09c3de6210f3f7d51733733"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "ae76cf27ea21430a5098d5ffa1d8813079b0816ccfdad3d8d2088a3fffac9357"
    sha256 cellar: :any, arm64_sonoma:  "2d4c34c93a8b89653aecb8e6b8822a6934dddfd4699f9e9976e349a4efc72981"
    sha256 cellar: :any, arm64_ventura: "b2b5faafb46f4d5a3d655a8584ea77195e3be9b5094e2109bdcc392cd9c258e1"
    sha256 cellar: :any, sonoma:        "c87786e37f9658b303a59f10284924c7ec6bef668f061a5f35a2397ee0ce37b8"
    sha256 cellar: :any, ventura:       "649ab7af700178f2b26159af86bc1ea626d34171b8ac3de2ac143214fcd3d6ab"
    sha256               x86_64_linux:  "977cd7ed73b7bf40c28d1fc452ce79b0459ef5fa0b185fef93a353fe74dff903"
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
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "src/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"xb-tool", "-h"

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
