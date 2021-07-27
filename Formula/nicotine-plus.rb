class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/90/7e/4f7a0b949998ce2bbfa9860a5f3ed74fa080c816501d5126e4cbec716c9d/nicotine-plus-3.1.0.tar.gz"
  sha256 "afa8033d4c07a58e79e0998fdd41d2f1fd5f93b196fdf76f1822639efd0b60b8"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbcd856e88efa6227030bf3068d523280a036099f6439f0967904f10f104c126"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
    sha256 cellar: :any_skip_relocation, catalina:      "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
    sha256 cellar: :any_skip_relocation, mojave:        "9a339a40b2a56caf796f0234a37d3db76d0954c3d2e03ae2fdd13b38198e7ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d2d856ebf3347fc2bd22ec79fa1626e0c4f65f09cfe28968aca49c18c8e53dd"
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
