class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "d259b81f2641613192ef00612a58a817e3cb04e83ee56f8e2052d70cf403bf7f"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42009dafd658e604bf809f2a953db1a4f079bc92f06acb7b5fc9edcb767979d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543897832fe9d0e7bfad1ca0304fedc56af63970b82af02c21e5d7279ad49b8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "518e1d996971fb0b770d32764123fdf7d4a9246d9b436909bd697ab0e79453ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cce6c1a95c360f545944874ad517b4bfa4d4f2c5edcc39df23c337a5b392ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "010bf1fc0b69e2861e22fa720f862bd86548f41ff7bf84fcf738f489bbc393f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b98b914f8fd3d8d4d80d137bd262af2ee348fcf6cde712174bdbc4f7f251c2"
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
