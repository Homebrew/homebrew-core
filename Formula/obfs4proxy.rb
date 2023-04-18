class Obfs4proxy < Formula
  desc "Pluggable transport proxy for Tor, implementing obfs4"
  homepage "https://gitlab.com/yawning/obfs4"
  url "https://gitlab.com/yawning/obfs4/-/archive/obfs4proxy-0.0.14/obfs4-obfs4proxy-0.0.14.tar.gz"
  sha256 "a4b7520e732b0f168832f6f2fdf1be57f3e2cce0612e743d3f6b51341a740903"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(/^obfs4proxy[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4794482e9011498f424c15acb994d2f2b50ec6278e41167c6541efe69badb3f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95285e769376c5e715cafbb68aacffc785765a638212d9d4bbfef593d65b42cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac853ab274e5754ee091c84217be2618d4381200ecef0f3b1a0c0a3845dcc31d"
    sha256 cellar: :any_skip_relocation, ventura:        "7a774c124868d26ec703c2d78d815073e51d398c7286da2147e7951ab89cc7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "54d52bb6d65f47e8076c15a38f07e5b3e0f9545944ea627960ce2037913723b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2015fe28393b6794fc18d8090732ce733d14c9b331fd0f8f123eeb87760bbc8"
    sha256 cellar: :any_skip_relocation, catalina:       "dcafd8b0d2cbcd4f22ccea0761a532220d40af53c95164173d7ce3c25331ecd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4f95197e4ffd99a2a8e43f674eea3087cd43bbbe4a5ea38a396c32e3a97bb1"
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
