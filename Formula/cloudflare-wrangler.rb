class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.9.tar.gz"
  sha256 "5320dec5bfd587dab11306511c50c4f7e4a8cadfdf2fba2b360e44e9bc764c90"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeb7fa2d33204be11331b840bb49ceeca3857dbd095effea44238f332384988f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14ebb018edee7d1205a0fdd19411df77852e72244606173e4b8ff485b4b452f4"
    sha256 cellar: :any_skip_relocation, monterey:       "fa394d9fc846966ce31f21bb35db8d97ce36ff9410f553b852a54b3176c0b234"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b4c3500ec219e73bbd17781c75dd4bc9518350e14417fc47e377bbb4a6f0906"
    sha256 cellar: :any_skip_relocation, catalina:       "d9ce4eb4b7dbff8993cd5a3a08899b3791ec2592d6c04364a5b35b011640afa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f0489ec047b35a63fb63fb0405d6891c3d82d791f0a68bb4a4afa464c417bd"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
