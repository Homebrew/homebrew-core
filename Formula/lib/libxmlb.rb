class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.27/libxmlb-0.3.27.tar.xz"
  sha256 "63fa0275f7454d77c10e0af37f79dfdb071821caf429a57dbd9598ea3a9defd6"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "120816663f8ba794566de8da00a63f09bfa240c421f63d7c472acba407eccdbe"
    sha256 cellar: :any, arm64_sequoia: "ac73d2e3d04f7ddf51298c32aeb2bc489a8ec8edce256e368d99bff2523ab514"
    sha256 cellar: :any, arm64_sonoma:  "76091a4c52e65f0186b6cabcd3b090a78ff32fb9ba709502a906d2ad37682eb1"
    sha256 cellar: :any, sonoma:        "b164a5170af54cf0e0cfad9324463401fab99d87c7a482a0f0c343afaf19da3e"
    sha256               arm64_linux:   "5532d4dd0ecd14bd730d12c0f24622286fa4ddafc79463b93d0585334714b6d8"
    sha256               x86_64_linux:  "f185f321d12c0810b383e3fc289fd35c1ec416f5d9558f8e05b7086180699319"
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
