class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "244345e42813df6c141d986da74bdea27e09a01ee63024f0ea00d6f8d746490e"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d71e69723bac56e90c882bb0843c2b6c27ef17e18ff4039153fed3494d3311a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8e2cdeb300c0496ad29e1ea596565b5bc56e148eb7680374199b6b252cce980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c80d755fcc277f23d6323cbc59a6d7ec1162fd940e1bdaaaccbf6197f30c11b"
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
