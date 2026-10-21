class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "3094473a2eeefe10d2670537be107d068b7324231ebf031c96ff77e391d6e725"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3eb7b02a7a408c1d2aaf16fc7b37191aeeb0790456aaa7b9d88763e1a43d11e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3eb7b02a7a408c1d2aaf16fc7b37191aeeb0790456aaa7b9d88763e1a43d11e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3eb7b02a7a408c1d2aaf16fc7b37191aeeb0790456aaa7b9d88763e1a43d11e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad319620ab05ec01dfae00255a6556e1ca3ba9626f62fb5352f3ad6fd4c9f50a"
    sha256 cellar: :any,                 x86_64_linux:      "e3e37cee189689f4b0e0c8be338ff2cc77cd8458dcac841109b54faee0c02d0e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
