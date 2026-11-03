class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "4a873aa6fe7fd66ac47df3b0a34038771b4a17b11e0894c69263138fc73208c7"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "667c86eba6a8eb1af9c67fc7d6c3a4aeefb5595ee27fbc333d1698ec3e361190"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6dcd8c7dab7e6cefcb1460d70aaf3c79c00701f514ce9100165c1811f4637e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4871a6cffaab7c1a314b2f9c3fc2e6610a568a9e9db64950fface2867d0a100"
    sha256 cellar: :any,                 arm64_linux:       "efaa20bee40ea86bed3baa72574a05ca3b710635244e649b087d2c6cdcd1974d"
    sha256 cellar: :any,                 x86_64_linux:      "255fd9acc9706a89c59658d6586f0853de20482f09ea7ea214f83a0f8b16b059"
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
