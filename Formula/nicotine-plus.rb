class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/7b/15/a2bd4586013d77252ae354c8e6ec08464801c717255a0d3a7b3dff79f786/nicotine-plus-3.0.6.tar.gz"
  sha256 "06c6456c71943b35b3b23d3d958ab8c34e6471da0e46a615ba53dfb4db2a408c"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76c6b9d080f170125331b549cbb496eb3639a757cdcd6b4056ec5a98afeeb533"
    sha256 cellar: :any_skip_relocation, big_sur:       "0997da63eb74d5138330ef9bd0f82635971b29742f13e2d01e2c0f73fd8d64c3"
    sha256 cellar: :any_skip_relocation, catalina:      "872762c2cc58bee642e35770637471bc78533c379a15935e62e0d90406767fd2"
    sha256 cellar: :any_skip_relocation, mojave:        "7c97cf043c4ad24779b9e8f2ac571bcc728044822b482fefaa8f29be663b1cf9"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

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
