class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "71acde630e1941f5e520ce71d6eab0fc2d655e5d1769b22930a73ff354d78069"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c633cd083afd187ac0dc5e4e60c8ee83971f73b8c39414745421fccf1dee3cbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9f653f91d0e23958b0fb229a5dd508adfee01eb96bc1e132bcb45a0f3ff1f49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80883e168dec66fd24555d953217b79205b9d878ecd599729bef78fd630019cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cddd49421d3d268cd930eff5d7a2e7e744437cd05be1121e5089b3650a10382f"
    sha256 cellar: :any,                 x86_64_linux:      "903d5a0ef3e8978dccdfaf0c80091cf9316c3d0de16511f9cccc48b3f539496d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
