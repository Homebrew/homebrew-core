class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/e5/19/b4a0816ef995cb485443ac7e5976680d0ae207081bafefecdc83fe4d4f9b/nicotine-plus-3.2.4.tar.gz"
  sha256 "0b6b9fdeec7e331bef587930b1eef3f8cf4dd8d4f77d253e2dbd7ef5ce96f54e"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95ee8e5d6ffa6a1876d7381ceddab0eb15fea742044c12405c68f1baafc6864d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95ee8e5d6ffa6a1876d7381ceddab0eb15fea742044c12405c68f1baafc6864d"
    sha256 cellar: :any_skip_relocation, monterey:       "370c1acc977e187619acd0742d63b32491f706b8ad798cc20b9c107496146206"
    sha256 cellar: :any_skip_relocation, big_sur:        "370c1acc977e187619acd0742d63b32491f706b8ad798cc20b9c107496146206"
    sha256 cellar: :any_skip_relocation, catalina:       "370c1acc977e187619acd0742d63b32491f706b8ad798cc20b9c107496146206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1e37d9423459e3166f77096615769ed3cd37c2b1cb53da637cf9f5b47fcc18"
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
