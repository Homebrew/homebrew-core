class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.29/libxmlb-0.3.29.tar.xz"
  sha256 "448294be33bfae62f00fa66e506f1cae80237ce71b7ab6530aefa75005eeb08a"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74ca7fceb54bfd53a6cde29046221ee8aba126cfa46606c5cc77686f1e5fb4d4"
    sha256 cellar: :any, arm64_sequoia: "db700b5477855d7392277d6e0c6e2adb5d2ef8bc7a85a43f898a825bd02112ea"
    sha256 cellar: :any, arm64_sonoma:  "7475e67ffa742121e2808fa7d462b1e8e4f065f1d00a4ab9eba5d3711d25722b"
    sha256 cellar: :any, sonoma:        "f780e8399cb1b3ff57373f2c5ba345d0f454dc41d531293483e8421e07dc8440"
    sha256               arm64_linux:   "17e851b7249e9176ecf9219a7a64a3f82ffa8d82a74cbb79c4d63357df27f95a"
    sha256               x86_64_linux:  "a64a9b8b8e43a14508becec1a0e7a2948cc2b605587d36f58d1ef85af5ad557c"
  end

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
