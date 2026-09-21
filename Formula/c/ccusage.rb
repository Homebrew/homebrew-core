class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.24.tar.gz"
  sha256 "04a3d984ffd1d8799124c26197aa82bebf51dc118f31cba1d15a5376bf08db8b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce69005cc5fb2ded26ddc283d460190ad390ce041873bd837ef6db844dad45d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "000075363374cfe64cf71c2521c416156a3fd757f14ea2e94dd74cef0d05b694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23bb4550bce12121527cc4e5b4ab90b881b4cfb76e832c0b2ef8548b3223c6c3"
    sha256 cellar: :any,                 arm64_linux:       "d87b1d317f1e9176fb7a884fc4c5d80ec3556023628a5c1a5e9d40b31eb9f7a1"
    sha256 cellar: :any,                 x86_64_linux:      "d6cfeb9c26100310e9b2af459fdfa4dee9d9b4a945b3bfa9365f5f5ae09f0533"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
