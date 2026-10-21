class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "230a5ecac583107b94d33ef9e603923278dcdda40c7e14d909e413657834d99a"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25f181eb4313b661203dbf272f42d4d18e4f07bf4dba65fae0fc11a791a43ce0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fef050bc617376896a6a34695463e1fdc7d10eebdadcd56e8e8725b95fd5a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "84a47a24fe759982ae408d21a3dda4b245fa730e167580ef5e25e3d1c7ff2e4b"
    sha256 cellar: :any,                 arm64_linux:       "486bb96d142b604f16ddfd3debf84884e4790c3931dea7c4bc2646502f9be8fb"
    sha256 cellar: :any,                 x86_64_linux:      "d4ad82e90d3e24bd5b3bb9cf5a0b9b815bcd56448cf0a05c698b18acde1ebfed"
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
