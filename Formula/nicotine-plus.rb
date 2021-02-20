class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/f1/e6/818eb82e9cfe93dcdd769bfe111869a971fb94c2ca7fedbfd44236f9c676/nicotine-plus-3.0.0.tar.gz"
  sha256 "814d7b8c9a07d211a0b36b21a5b075f38db3840aaae26dd2acd42ac90b71cc60"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "640070846033d7888c8e1f317dc32651a753054f0ae12cf9c1bd4fd6e6eb7db9"
    sha256 cellar: :any_skip_relocation, big_sur:       "8993703de6edb67c8a589351cc80bef9d71ef442121a50eedc4ae04af94f08e6"
    sha256 cellar: :any_skip_relocation, catalina:      "4aabd1510048c5478cc61d007724eed18d6cd1900cdaccf4d1a265ba0769f5f8"
    sha256 cellar: :any_skip_relocation, mojave:        "47381e0a67386bb8bb7603929ba539301f2167cf95ee3274dbb08bf53fc26ea3"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
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
