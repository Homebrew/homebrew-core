class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.4.tar.gz"
  sha256 "200e5e5d10000fd8a94239f51cf0574d216a91ce849b01b75bd1c64d12ed4f3b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fafda9da0bbf3ede13b5222d7551be80e2fadb0f6ff050bda458c05434ce6621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fcde20751e1b302d0207d855b53e0c9ab0b0419ec90c5cc6b22b23fa2ce23ce"
    sha256 cellar: :any_skip_relocation, monterey:       "37554b835913ca5a13845181699f75532281448bc5f96f2e83804900b531ccbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "03d2c322d0257021ebb30d52b00f61d3fdc713248d65f8448f7e7b78aee3f05f"
    sha256 cellar: :any_skip_relocation, catalina:       "f22ccd3a30bd254d8e8122de9156258b069fff7b01fc74be45b37876888b24df"
    sha256 cellar: :any_skip_relocation, mojave:         "2d5bffd37b034879545f1c2d3b7c18b2d111860b88e0d86946ef91af25b8c9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36fbdc848049537e88dd511a26535738c8add82f3a1a8dcc39e911c0edee9a10"
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
