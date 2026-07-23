class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "44e8c221ca9c4db39a4f48b81154ba3109ef91307430570727302ea353f50056"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0be95ad1a744edd330dbb973e6e19fb0b6ef29da99334069b63a0c948e948e90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5e2645b9962c9ef30bacaeb2b01034380efd296c9e3467f10fe9c5df499bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288e192d03f737af2fbb9d732464619f223763cad46cd64114dd0a44297297c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb8b5acb7c445e66b1fc984ef2205db79dcb746e324588eaad605b83d05ed45"
    sha256 cellar: :any,                 arm64_linux:   "20da6a17615d3df6921db04f6a0d39ffaa11ac513c5b7b09bc048622e8980f30"
    sha256 cellar: :any,                 x86_64_linux:  "4a3ac79aad60e3f544384a6591e1a32d62011809ade455c1ff58fb3033c70065"
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
