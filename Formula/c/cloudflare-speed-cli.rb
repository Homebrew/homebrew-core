class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "5e846dbbc50200fd75542bd68159f322fc2e3b1b7ffa43e4e7c6c8f9b6e4d34e"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5f0d32eccf7e416d3f93c9df2f5532d942c26701e82ca6166ac6a09a6bfc1f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b2427be88d9bba7c591da87c5d95f4c59d839bba0b832a23fa5636b42bb8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4daf9c46d1fcd3e7230292bbc4cd2eb8678a9e0d18b49685b6bad82d1135c0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2d537e9961cd913993831b6d38dc011e7f41389dc5cc39baedb89696e8c8857"
    sha256 cellar: :any,                 arm64_linux:   "63237263a83596997a13d50cdd5a582f6c1702db4fdb17551c5812620b2288d4"
    sha256 cellar: :any,                 x86_64_linux:  "781af333778d9c4bda79331acb8a389bba4ab677374347c619a524fc461ce69e"
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
