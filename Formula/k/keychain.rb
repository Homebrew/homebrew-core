class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.10.tar.gz"
  sha256 "9e2b68016faa6eef0f67584aa5f2889bcff71369b9246251095dc38fb839d035"
  license "GPL-3.0-only"
  head "https://github.com/danielrobbins/keychain.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0e239b2dc35c2ce8fcb51c11d384defa420a410665d9ada3a20b5bb732ad9fa"
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
