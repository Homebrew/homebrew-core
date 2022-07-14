class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.37.0.tar.gz"
  sha256 "f5650e26638f94954d0b89892ac0f4241cfeb55c17f555ee890609544ea85474"
  license "CC0-1.0"
  revision 2
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a8717f9137b0e53d2c676e47251319527e54831f5ddecbbb55fcb132c944eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c51e81cb6a59c05692034deb9d0b19f4d76e60159315db30a488a2ba662fbc5"
    sha256 cellar: :any_skip_relocation, monterey:       "145073de4fd482eda6d3f9962a7886f3df9378c263b0465003f2283e18b781ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c93983a106e1ee1c9b7560c667b170a43d3f477d753d29e7cb12719ebf810b87"
    sha256 cellar: :any_skip_relocation, catalina:       "a5725aff678156d34575f9cc280ca62a67f8e8dbdd7d46178d1285bc37f928ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce93bdfd7201b1757ddbe38e08631dd293cfbf8be1cac25e76e27c8155ced3d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"meek-client"), "./meek-client"
    system "go", "build", *std_go_args(output: bin/"meek-server"), "./meek-server"
    man1.install "doc/meek-client.1"
    man1.install "doc/meek-server.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-client 2>/dev/null", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-server 2>/dev/null", 1)
  end
end
