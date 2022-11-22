class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/a1/80/64ea2d929cf23285964140a43c1f364ed803dd10bf58f77489dd02adf26a/nicotine-plus-3.2.6.tar.gz"
  sha256 "afc8d1e903413a2f844c60aff8b241b2c62268f9d26fea1fb6f81a622583ea56"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb80ddd865a0ff5f766a5bf534b3563546c47fc27b0fe1821c2823d6b7cb5782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb80ddd865a0ff5f766a5bf534b3563546c47fc27b0fe1821c2823d6b7cb5782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb80ddd865a0ff5f766a5bf534b3563546c47fc27b0fe1821c2823d6b7cb5782"
    sha256 cellar: :any_skip_relocation, ventura:        "1a8a4981c4c5b4c0d9bad7c843cd1346fbd124cf882e6cf99781a76252121060"
    sha256 cellar: :any_skip_relocation, monterey:       "1a8a4981c4c5b4c0d9bad7c843cd1346fbd124cf882e6cf99781a76252121060"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a8a4981c4c5b4c0d9bad7c843cd1346fbd124cf882e6cf99781a76252121060"
    sha256 cellar: :any_skip_relocation, catalina:       "1a8a4981c4c5b4c0d9bad7c843cd1346fbd124cf882e6cf99781a76252121060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be7cc8f92630bb307542d5c9318406ffa3828ade3b304338bd688530ddb5292"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.10"

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
