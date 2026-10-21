class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "3c7dcff34813bc09f50d5cf077e17ba6e8ca1d8a7509513d07597303b37a10e7"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1045e45fd1ecc443501d9bbf08eb4ef5be07e1e968a11772e1b7f5bceb077595"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8ecb628af81c224e69ff23fe52ec2a1736b725772b93ce780e6b62ac869a426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "baff2eddc183c0c4b1ec0735eb9a39a1ca4e4d7a86a623d40e3e7882c686e8ee"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "hw.nperflevels", shell_output("#{bin}/macmon debug 2>&1")
  end
end
