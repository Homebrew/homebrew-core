class Obfs4proxy < Formula
  desc "Pluggable transport proxy for Tor, implementing obfs4"
  homepage "https://gitlab.com/yawning/obfs4"
  url "https://gitlab.com/yawning/obfs4/-/archive/obfs4proxy-0.0.11/obfs4-obfs4proxy-0.0.11.tar.gz"
  sha256 "46f621f1d94d244e7b1d0b93dafea7abadb2428f8b1d0463559426362ea98eae"
  license "BSD-2-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./obfs4proxy"
  end

  test do
    expect = "ENV-ERROR no TOR_PT_STATE_LOCATION environment variable"
    actual = shell_output("TOR_PT_MANAGED_TRANSPORT_VER=1 TOR_PT_SERVER_TRANSPORTS=obfs4 #{bin}/obfs4proxy", 1)
    assert_match expect, actual
  end
end
