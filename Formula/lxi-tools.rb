class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.5.tar.gz"
  sha256 "e8ccefeb907da1dacecef2c5b8bd0c1a841003a4d1309143426f860ff8c14bc0"
  license "BSD-3-Clause"

  head "https://github.com/lxi-tools/lxi-tools.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build

  depends_on "desktop-file-utils"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
