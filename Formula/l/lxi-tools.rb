class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.8.tar.gz"
  sha256 "ef9d013189c9449f850d467dd35ac3840929e76a888cdb77e0edbce067da0b2d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb9a2f4a9856de51cd7b6f14d9a81ceb995fcc8405f83349701068a428c653f0"
    sha256 cellar: :any, arm64_sequoia: "3975c597f3477521ec7110dade8261a4c3ea66920e6054c3ffcd3dcb2ccbed3d"
    sha256 cellar: :any, arm64_sonoma:  "d0415c9dcb1dddd63a53e6ec24d16b3a95d324aa8d6f319db75c7eb2871ef953"
    sha256 cellar: :any, sonoma:        "00cef47683c1a2b249a1ee5fea163275d0c8f883f23434d6e8d23e3b35d457a8"
    sha256               arm64_linux:   "5d9c0399c7871eab15d70272c56a636e8fbbf4c755107b7411957dc1c44e83be"
    sha256               x86_64_linux:  "878f35d6506d8e5b11f207a6cfb2bbcc4a0e9c013a27b11a9f9990888d38b523"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "desktop-file-utils"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "liblxi"
  depends_on "lua"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
    system Formula["desktop-file-utils"].opt_bin/"update-desktop-database", HOMEBREW_PREFIX/"share/applications"
  end

  test do
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
