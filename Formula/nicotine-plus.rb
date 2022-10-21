class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/a1/80/64ea2d929cf23285964140a43c1f364ed803dd10bf58f77489dd02adf26a/nicotine-plus-3.2.6.tar.gz"
  sha256 "afc8d1e903413a2f844c60aff8b241b2c62268f9d26fea1fb6f81a622583ea56"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0362859e0482ef9eef6e14fc46463e56dde517f058108198d4c152f83af6585e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0362859e0482ef9eef6e14fc46463e56dde517f058108198d4c152f83af6585e"
    sha256 cellar: :any_skip_relocation, monterey:       "4442e32926d30d4c0e34980d627ba2d75cdef3e086019c84764db831db9fe0a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4442e32926d30d4c0e34980d627ba2d75cdef3e086019c84764db831db9fe0a5"
    sha256 cellar: :any_skip_relocation, catalina:       "4442e32926d30d4c0e34980d627ba2d75cdef3e086019c84764db831db9fe0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1992d35a5c5c5f10ca06c0f1d6cc18bb067d3421c7783f40bc1e5a57827305fe"
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
