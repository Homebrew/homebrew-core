class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "e93e8e9d3708825b55911d6d97d755539bc9d94647713f01051eee2ff3c5eb5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdd0eae2c28daa3fc037ed8d997bf693e0276aad027e47b007ece373be942e97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34b01449771bdddb4fbd2aa507078f319c34b4152634d2ce3e2a960158dcb97b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5082a2d332253d4b54cd8cc999c1ce83c87c5f4a68bc96b30f5b2b9412380f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f76f632632fbbe56794fdbbbe6801b1e826fddcb252215ec137da771d6763346"
    sha256 cellar: :any_skip_relocation, ventura:        "0210011b5c8ade61bfb314505b76f03f37ca42b2e9bdd1aec61fb2908e63e924"
    sha256 cellar: :any_skip_relocation, monterey:       "9a8c47ac6209bddb4a96bcbda0d661d2fa242f131fab054da653f2292c167957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e363f3ccc3f7775e8e78945cbe640cccf7afc6e88d0e5ec97f3f71f19a4cbb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to initialize database", output
  end
end
