class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "eec13a618822efc5f48d05fa15c1b497ca3804ba2701be732106f6b10f96dfde"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4510f19b6c539592cdedec6471440f90655ca17e690ac07cfdd0362f201ed5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c434ba02506fecb1fbe48ed27456a314b8fcfb4e62588a4a6578d2142a2dd004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c13ce55c9125391c74044b01a4a20fb0f54aec09b41fc60bff50602d26ed90b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "99216e9ed7d6f8d7d37c752803d8492ecee6368651fb35e62bc65e4cd298c7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e96345c84dc477c7f34cf57db3d503ce07f131ad2baebae6d7cb4007385a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2721b61aad81f062b4647be32dfe5e6610dc186be42906137f75887d306b58d5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
