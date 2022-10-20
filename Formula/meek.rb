class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.37.0.tar.gz"
  sha256 "f5650e26638f94954d0b89892ac0f4241cfeb55c17f555ee890609544ea85474"
  license "CC0-1.0"
  revision 2
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450bac780a75f6f2ed4f15c2a35d771e745ff2fa14437f67c2d98b6ac81ff71d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4150fa754142277de7e577a37cc4f39ad2aae4bf6e2a2e4535d51435fda6c23a"
    sha256 cellar: :any_skip_relocation, monterey:       "469a97cad0ade9b8ebd16184580088da156dd0ed0233c6f320201a728c02b3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dc0edb859bae8e2fdf441fedde9c8d5ce4c5f75da7fca62bdac4bda46a19ccc"
    sha256 cellar: :any_skip_relocation, catalina:       "0cee6a902cf7602b4726a5552d97d9eeaadc4772f8e164e0f83315b64c3b0b10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2efd74e926c7b12e1face590d3d00331e31a4b6b1c1de96dc010879cd6c2f57c"
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
