class Keychain < Formula
  desc "User-friendly front-end to ssh-agent(1)"
  homepage "https://www.funtoo.org/Keychain"
  url "https://github.com/funtoo/keychain/archive/refs/tags/2.9.2.tar.gz"
  sha256 "508ae2593e38d2fa6b9fed6c773114017abb81ef428b31bd28ae78d48e45e591"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db84c4a63443468017fffbcb174ba06dc3697c8a659722eb8ba112bb417b70fc"
  end

  def install
    # BSD-compatible `Makefile` is not working on macOS, so revert changes
    # Commit ref: https://github.com/funtoo/keychain/commit/516df473cfcc24ba109ceb842f7908f28f854f19
    inreplace "Makefile", /^(\w+)\s*!=\s*(.+)$/, "\\1:=$(shell \\2)"

    system "make"
    bin.install "keychain"
    man1.install "keychain.1"
  end

  test do
    system bin/"keychain"
    hostname = shell_output("hostname").chomp
    assert_match "SSH_AGENT_PID", File.read(testpath/".keychain/#{hostname}-sh")
    system bin/"keychain", "--stop", "mine"
  end
end
