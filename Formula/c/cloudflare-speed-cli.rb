class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "4a873aa6fe7fd66ac47df3b0a34038771b4a17b11e0894c69263138fc73208c7"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0e53e485b12c9b45fe53d36c4171ba150c3b85c51174528a554a4a4634d4561"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e50c3936c7eb57afa168ebe592f4012bac23ebc95d8b3c0e5d8163f7d7bf4bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3d118a437b02d6f8d397f4639d8fb06361e45884ecc68b1bcc51e6e9c9a051e"
    sha256 cellar: :any,                 arm64_linux:       "3c758fa4b24ca0ee92c71fa3ce1318733f54caac7368e150cf45d571d90c6a9c"
    sha256 cellar: :any,                 x86_64_linux:      "0b0587b35112ecde87c6676a72b65223b5b828d7c2d0056c3da85f20350e45f2"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --json --skip-diagnostics " \
                          "--auto-save false --download-duration 1s --upload-duration 1s")
    assert_equal "https://speed.cloudflare.com", JSON.parse(output)["base_url"]
  end
end
