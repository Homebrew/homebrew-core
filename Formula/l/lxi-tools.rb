class LxiTools < Formula
  desc "Open source tools for managing network attached LXI compatible instruments"
  homepage "https://github.com/lxi-tools/lxi-tools"
  url "https://github.com/lxi-tools/lxi-tools/archive/refs/tags/v2.6.tar.gz"
  sha256 "a36699387b40080ea9eb8b1abc14d843f5e7a33b3a62fcfedaea9cc54214bdc8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ad1eacf1e8ae219d14d1d0584f97da77fb4f866dcb2deb63b5a64278c21c492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f67748c50df2d75290b85eee36792ea4c8eb1b767a1fe81802a0aacf1d8170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df3254a41c62da6bfa63e8d7da78e9fb45cc2347710a3fd09dafa91e5d027a62"
    sha256 cellar: :any_skip_relocation, ventura:        "910d48ed42f6cdf76d6166df6343309d2e50a60550a44b7137cdf9d5000916be"
    sha256 cellar: :any_skip_relocation, monterey:       "4349534c758dad9cf5cbae6f2d799d5fb3be25887cd69d683ce921890ab55be8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f31f8dba717b9434e3798f090f68503aa633b44a4247bdc8a13a39c24961fcc"
    sha256                               x86_64_linux:   "4f84ffcf6baa6e46f5fa3d3555496db4f9dd3f0815a7f4faee51dae80bd77ad2"
  end

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
    assert_match "Error: Missing address", shell_output("#{bin}/lxi screenshot 2>&1", 1)
  end
end
