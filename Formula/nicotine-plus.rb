class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/ee/2d/d8fcc06fb78a294fbc399568fcec4a706c31a681b94ba25b009c8a4377cf/nicotine-plus-3.1.1.tar.gz"
  sha256 "ce8342fcbc4d6fd50b9c29465eaca45d35c8c7be0a3ef03f5c1d9a594d96ec34"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e972743e2f54137fa86daee847c43303eb90753c67a7d3dae780399413b39627"
    sha256 cellar: :any_skip_relocation, big_sur:       "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, catalina:      "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, mojave:        "8911f1a7dcf2871ec7bcb515874b0a35508d95a52077d660284b8593e19b5e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7c553b10e2f176f180e33f75f55ca0eb64b8f93f77667383f2d76f83cbde65"
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
