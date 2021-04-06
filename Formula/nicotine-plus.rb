class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/ac/4c/8756bfb6ac7434bda33b29bb8d6abaa8e8ca9a21f927beff6e4b2a6a2686/nicotine-plus-3.0.3.tar.gz"
  sha256 "7d59088cfae08539ddcb7d40c65fb267f746af0712b044b24c396a4f7224b568"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b4136f965306442c650b2de59859efc4e40a5aff3a755c41527d707fc2d6972"
    sha256 cellar: :any_skip_relocation, big_sur:       "b03a1dbb5b2c2e7ea5a1503aee224621da27c3a7bd13725390ba8ace0b95ebb4"
    sha256 cellar: :any_skip_relocation, catalina:      "ee2d59e9cba8ded41ed7a76553ff1b4625e2acbe85e2220a750de6ce0d59fe11"
    sha256 cellar: :any_skip_relocation, mojave:        "e10c26a215aff2521cb147251a149120fb5e1681e0eff7a0c8ca8fe90dd32991"
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
