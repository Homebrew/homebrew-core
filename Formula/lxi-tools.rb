class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.6.tar.gz"
  sha256 "a36699387b40080ea9eb8b1abc14d843f5e7a33b3a62fcfedaea9cc54214bdc8"
  license "BSD-3-Clause"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "desktop-file-utils"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rm_f "#{share}/glib-2.0/schemas/gschemas.compiled"
  end

  test do
    assert_match "Error: Missing address",
                 shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
