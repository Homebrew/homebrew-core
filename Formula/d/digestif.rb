class Digestif < Formula
  desc "Language server for TeX and friends"
  homepage "https://github.com/astoff/digestif"
  url "https://github.com/astoff/digestif/archive/refs/tags/v0.6.tar.gz"
  sha256 "7d957ddc83c621045c5f24d19244ecc72ce0ecd16518e7e13384d014300e3060"
  # See LICENSE.md.
  license all_of: [
    "GPL-3.0-or-later",
    "GFDL-1.2-or-later",
    "Latex2e-translated-notice",
    "LPPL-1.3a",
  ]
  head "https://github.com/astoff/digestif.git", branch: "main"

  depends_on "luarocks" => :build
  depends_on "lpeg"
  depends_on "lua"

  resource "luafilesystem" do
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink "#{libexec}/bin/#{name}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digestif --version")
  end
end
