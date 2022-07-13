class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.37.0.tar.gz"
  sha256 "f5650e26638f94954d0b89892ac0f4241cfeb55c17f555ee890609544ea85474"
  license "CC0-1.0"
  revision 1
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d19c3c39e282288d574f72c2e645d586514d5bdf9fa3adbd5dee9abce2c57c6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "381c30917d44d9950043b015da64076b114280c08cbfea1535c4b89544c2d3a4"
    sha256 cellar: :any_skip_relocation, monterey:       "67abc74d5ce920c2d4c0f6802c5995323075b12c7bac5c1bd46748961677b590"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a8da9ed8871a4dc06b5e7a772f1fb230a12353296af9b4ceeef8d08d6cbd49"
    sha256 cellar: :any_skip_relocation, catalina:       "84d861c8c71758f0ad3bcdac328252548a049abe9303a09f16892cc6971a4d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53df0b92961c12d36c251b736401699ce3cd9d0527c5ff0e5f4e01369998c18b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./meek-client"

    man1.install "doc/meek-client.1" => "meek.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER environment variable", shell_output("#{bin}/meek", 1)
  end
end
