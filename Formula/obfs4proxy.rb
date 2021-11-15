class Obfs4proxy < Formula
  desc "Pluggable transport proxy for Tor, implementing obfs4"
  homepage "https://gitlab.com/yawning/obfs4"
  url "https://gitlab.com/yawning/obfs4/-/archive/obfs4proxy-0.0.11/obfs4-obfs4proxy-0.0.11.tar.gz"
  sha256 "46f621f1d94d244e7b1d0b93dafea7abadb2428f8b1d0463559426362ea98eae"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^obfs4proxy[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d7b477385d289553a2b0e4f24d388f4b5251050945b734c1bbf984352b6ab47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e7ffbf5b299d80b469fc0f4edbf44dcac2c698a7b5ac84f4d78632cc8888ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "a460c5414796f401619ddca98f9bb5c807dff41071099f0d3ae5fe0d85536538"
    sha256 cellar: :any_skip_relocation, big_sur:        "5918cdc41743f14ee4110b132361abe21b20445fb7afd4a60859b4b1e594462a"
    sha256 cellar: :any_skip_relocation, catalina:       "4d22c53ebd7beaacc0c96b2af4fe3179f5b8a63f2f9bd624dc6d0d1d2867d40f"
    sha256 cellar: :any_skip_relocation, mojave:         "75715a8bfc51f3ab2a3dd4e56077c27626ffd802a83f18da300d394091fb79cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4406d6bb3e815416d79ccdec2df0217aadc212387dce0adf64ad2cb9f6e56d09"
  end

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
