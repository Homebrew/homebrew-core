class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.38.0.tgz"
  sha256 "d0aa2ad761249df5d196444911b23807767e9118fd488976aa9d6b3b6ca25bce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ab309a45cb06c0c8b11a7abdd4cd5fd2ec2490c71c554ddbfb2685542f95e40"
    sha256 cellar: :any,                 arm64_sequoia: "94c2222ee5e8abcaeebe16610bc9f4eb2724f82047864c64cfe8575c98184fbb"
    sha256 cellar: :any,                 arm64_sonoma:  "94c2222ee5e8abcaeebe16610bc9f4eb2724f82047864c64cfe8575c98184fbb"
    sha256 cellar: :any,                 sonoma:        "fd1e547eadaa001bf4b9b810e9d50126bcf7149e008300eb1e1830df509771a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22745346d78f64e92cd95f5727e52741af11014614231028be1577a925ce1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9765e408ed9c68d8a98d335d6107c424ffde3552c4efce9e75aea5531ea2581d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
