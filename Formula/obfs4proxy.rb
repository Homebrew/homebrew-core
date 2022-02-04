class Obfs4proxy < Formula
  desc "Pluggable transport proxy for Tor, implementing obfs4"
  homepage "https://gitlab.com/yawning/obfs4"
  url "https://gitlab.com/yawning/obfs4/-/archive/obfs4proxy-0.0.13/obfs4-obfs4proxy-0.0.13.tar.gz"
  sha256 "ddd9291cb7c41326f076f622118816f09148e1aac79ec440d46436e802918e84"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^obfs4proxy[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed1aa9be83a50078397b3f8197b993edb9ad483016cbca4c48a763c36422b3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91c4ac96b8887773ee92127f0e2bb106241da8a772dc4b65127f1934ac7c0079"
    sha256 cellar: :any_skip_relocation, monterey:       "c2b8c65b95e87e92cd42b0f9d7ef9de95ed916952ea077ef383fa77d6f0e1b89"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9ff421b761f41bb71fa9e0a6836ed2e53221220cd27db52b3fa17931217264"
    sha256 cellar: :any_skip_relocation, catalina:       "14ca207dcd1c53cce9c0586a731b79fc79259af386765e5405ba2451f892b5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdac3ecf99f7e09533e4b78427bd23610225bd13cc363fbd5d49004db9c371d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./obfs4proxy"
  end

  test do
    expect = "ENV-ERROR no TOR_PT_STATE_LOCATION environment variable"
    actual = shell_output("TOR_PT_MANAGED_TRANSPORT_VER=1 TOR_PT_SERVER_TRANSPORTS=obfs4 #{bin}/obfs4proxy", 1)
    assert_match expect, actual
  end
end
