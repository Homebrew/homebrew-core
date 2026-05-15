class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "eca078485902142f4bec3f10ec4726ca959c9f79053a9ee358860e1e9e3b9efb"
  license "GPL-3.0-only"
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2944b76b2aa478d717862dd7fae180f53942d91ce852e54e8130e53aec6d0ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cd3f7822b516185ce89e51b4fc316f409336fd076e6d6bb77c0199d6f2c534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b52093bf3d87ce2a6032071605261f1c05d7a52b29d7ef5e8a17ab12a0222872"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa83ae1f1ad6a24b80efb2787d79ba91e54c4405b4ac7473407d72b329cc26c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42aea6f489515e6baf870620ab2ba5d21c6f6f61e9d8f3565a20fec49c37ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6809a5ce31a6d06bcc000fff313bc7f83f4529ee501f56d010f82ed1c6ce6020"
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
