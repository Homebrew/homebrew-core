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
    sha256 "79f838b75ca361f58760ba72b1249c7713def0cd7aecf4f6d08ea111989cee50" => :catalina
    sha256 "21e9579eb01c586c391a5d23785021ea10be26fd493bce2592cb1ea7af59c582" => :mojave
    sha256 "c82082e0ff3002617e91804a3539c34c19170bb1f33c057c7f69198569a1177a" => :high_sierra
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
