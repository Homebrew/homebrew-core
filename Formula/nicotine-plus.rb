class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the SoulSeek peer-to-peer system"
  homepage "https://www.nicotine-plus.org/"
  url "https://github.com/Nicotine-Plus/nicotine-plus/archive/2.1.2.tar.gz"
  sha256 "3ed18ade97183c632836eb8e304a515fc19a35babb46cc6e6747bcfd8205dcdf"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    cellar :any
    sha256 "fd36296a9ab57c9f59b00ee8f8aa82fa59bc968af16e3fcb60508301e0720fa3" => :big_sur
    sha256 "26558aa583525e7e3b7c4316a50a459adcd00dbf92b548830931844c1db0f879" => :catalina
    sha256 "23b3b9539a553e7a282a3b2891ca0c3c02d62ae77dd807c8012d5234746de1a3" => :mojave
    sha256 "a38b6cf787524bcb0258233f2c5c8209a5d2b8293a440426910509138c5020eb" => :high_sierra
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "taglib"

  resource "miniupnpc" do
    url "https://files.pythonhosted.org/packages/0c/e8/dbb2747230dfd98a6138cb65b322072eade4d92e1006e518c8711f8f5b85/miniupnpc-2.0.2.tar.gz"
    sha256 "7ea46c93486fe1bdb31f0e0c2d911d224fce70bf5ea120e4295d647dfe274931"
  end

  resource "pytaglib" do
    url "https://files.pythonhosted.org/packages/c7/44/f054737af93d8bc57c3a23906e4e7d1b5538c7d96577746e5c4b2f92b181/pytaglib-1.4.6.tar.gz"
    sha256 "16daf54e78fb56442293d20d7659097470ecac9031f33037f9d53baa31382952"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
