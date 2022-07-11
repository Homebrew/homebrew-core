class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.37.0.tar.gz"
  sha256 "f5650e26638f94954d0b89892ac0f4241cfeb55c17f555ee890609544ea85474"
  license "CC0-1.0"
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"meek"), "./meek-client"

    man1.install "doc/meek-client.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER environment variable", shell_output("#{bin}/meek", 1)
  end
end
