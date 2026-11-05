class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.9.tar.gz"
  sha256 "e636a29b95381fc578f5d2d48c903a057baaf012e5b0b9979b3f12429446085e"
  license "GPL-3.0-only"
  head "https://github.com/danielrobbins/keychain.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "beb2af9a5175ab5ac6582ccff5028ecf2dfc26808b8e36d739e69afdff806a16"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.15"

  deny_network_access!

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end
