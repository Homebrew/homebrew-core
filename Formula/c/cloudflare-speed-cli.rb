class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "258158b6d8828cc692f51027c8aee51b5f56d0023022ce918aee88d6a87dbad2"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "575cfba9dd3e1abb8f17f002364cbe0aa4d2ee0052351a1cfe77944f7e453be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23724d65182ae96879c96ed6a1ab7a33857603ad5900d3f8675b5cc21247d1ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9d981683f75bbd8eeda690e96ebf4ab1305944751b6af7ce553caba41fb751"
    sha256 cellar: :any_skip_relocation, sonoma:        "187fcde1f6a6e1f89aac7ec2e842d1c6ddb3237b8fc3c5ee68251cb398e1df35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbff72d869cccc694bf382913062b4c6e1123d0eab3ade6257c8034f81a7fe4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f34683394d1b62fb6e1c0a6807df866730d9983d0e09fd18112c29a1e150da"
  end

  depends_on "rust" => :build

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
