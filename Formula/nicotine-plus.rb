class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/7b/15/a2bd4586013d77252ae354c8e6ec08464801c717255a0d3a7b3dff79f786/nicotine-plus-3.0.6.tar.gz"
  sha256 "06c6456c71943b35b3b23d3d958ab8c34e6471da0e46a615ba53dfb4db2a408c"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbcd856e88efa6227030bf3068d523280a036099f6439f0967904f10f104c126"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
    sha256 cellar: :any_skip_relocation, catalina:      "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
    sha256 cellar: :any_skip_relocation, mojave:        "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
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
