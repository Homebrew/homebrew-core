class Digestif < Formula
  desc "Language server for TeX and friends"
  homepage "https://github.com/astoff/digestif"
  url "https://github.com/astoff/digestif/archive/refs/tags/v0.6.tar.gz"
  sha256 "7d957ddc83c621045c5f24d19244ecc72ce0ecd16518e7e13384d014300e3060"
  # Most content is under GPL-3.0-or-later, but certain files under
  # /data hold various other licenses. See README.md.
  license all_of: ["GPL-3.0-or-later", "LPPL-1.3a", "GFDL-1.2-or-later", "Latex2e-translated-notice"]
  head "https://github.com/astoff/digestif.git", branch: "main"

  depends_on "luarocks" => :build
  depends_on "lpeg" # minimum: 1.0
  depends_on "lua"  # minimum: 5.3

  resource "luafilesystem" do # minimum: 1.8
    url "https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink "#{libexec}/bin/#{name}"
  end

  test do
    assert_equal "Digestif #{version}\n", shell_output("#{bin}/#{name} --version")
  end
end
