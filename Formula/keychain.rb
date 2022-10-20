class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/funtoo/keychain/archive/2.8.5.tar.gz"
  sha256 "dcce703e5001211c8ebc0528f45b523f84d2bceeb240600795b4d80cb8475a0b"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/funtoo/keychain.git"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38a9acfd004abd466201585d76285f1bc852b4e517d0324908f8b628ff8508ac"
  end

  def install
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system "#{bin}/keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system "#{bin}/keychain", "--stop", "mine"
  end
end
