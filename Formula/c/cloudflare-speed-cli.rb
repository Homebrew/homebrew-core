class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "a4aec800e6fb9991b2e69b20c06d6703e3706b4fcf6ce60e9fa1e4ed64c815ed"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4510244acbe270a868282660e24bb059c8fa25e17b131f029d3a79f2c3cf23d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "692b078e54920e2a7ba165d27e38e4e5b8a8833c86c179a8276e4d9cdf062f61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7d5987ed34a6ac0c899087dcd7b15b40a4884086d5702abad373c2cf0550f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ffe09c913ed4e836ec2ffb1bc2823f1c26989b68e9b753a29cc36b72b02044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eb3fc0b8420ef2d11b79618b064ce69801921d325e43481cededf87cf876469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc3815b0dac06b95ba8ddb67b8c1cac78f35b7138341bc78a2afab8007c62dc"
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
