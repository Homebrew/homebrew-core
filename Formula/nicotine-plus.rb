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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e62f71395e288ad89101ef29d6353af641507c973b034ea3121582007a447ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e62f71395e288ad89101ef29d6353af641507c973b034ea3121582007a447ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "59b8e8eacccf8cc4a89c576844b45d674390541b83f4eb78e928fbe9563e21f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "59b8e8eacccf8cc4a89c576844b45d674390541b83f4eb78e928fbe9563e21f7"
    sha256 cellar: :any_skip_relocation, catalina:       "59b8e8eacccf8cc4a89c576844b45d674390541b83f4eb78e928fbe9563e21f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abd8d5ae97c5e288d35aed88e4992670de6493ff513a3749dd0bfcbbfd74237"
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
