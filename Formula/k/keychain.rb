class Keychain < Formula
  include Language::Python::Virtualenv

  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/danielrobbins/keychain/archive/refs/tags/3.0.3.tar.gz"
  sha256 "ef6e087dcc0de79076caca7e39b08d4b7794127c54155889d92c4ad2d3930d35"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88b3495e10e5ece4fbfa27fcd7e35630711309f7267832a0aff2c63209138243"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end
