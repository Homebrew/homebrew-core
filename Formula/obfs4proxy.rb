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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93d62e389d2a95d99dbba3121c32c45fb9ddb495d45b23c6394f5eb4f9668439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83afbaf10cebcf3ae178522b5736b999486cfc0f1fa5b8b6524fb37e19e4fed1"
    sha256 cellar: :any_skip_relocation, monterey:       "9d810f57725c7f3cca6dcc4cde5096c19394df798bd3bc3b34f3010b070f85ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1785e03069eee6c6f1444d19c5324744b634d57a92cf4ad58903f758302488b5"
    sha256 cellar: :any_skip_relocation, catalina:       "f00212d4731738a98dd08a38f938d4c19ebb3e4fbdaa904ff14157d874ed25cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccc315eaa5ed2e9eb9e4e094a9c04616dd3316d35cd7901a214843b7520cd75"
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
