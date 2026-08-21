class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "a510b28d7b70b5e5ca6e55c64e3342f938990a211f5ed91f4281c15464dfaa24"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a4368373dda605cf89e17e945f94edf809c92195ab79b7368ca67fd8a946d4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50d3b28e21b0c271a5561e59eadfb30f4201fe5ee114f8a96d9c81ab843ccf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc9f3f1470d858a8f0110e8f159573a881e3e31c9ad34fc0cb61423149049df"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb37f3d14362d728bb6022ffe6712f02239da3d33f1a086f4a1e09ecab2c47b8"
    sha256 cellar: :any,                 arm64_linux:   "bc3079375e454d81e673aacf592e4f4fa3b699a474e06581b5bf5e7f5f8638a9"
    sha256 cellar: :any,                 x86_64_linux:  "52de180827a471ebeed7c89315164091f5cbda56c3a487c2b70baf62a84b724c"
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
