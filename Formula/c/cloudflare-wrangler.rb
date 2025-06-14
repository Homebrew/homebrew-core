class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.20.0.tgz"
  sha256 "782d5d473c073f822f3dca1a59f58051ead2949580432bbc53e7e4fe2045af06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5086cd5702ad15af5b8c0d4508a799596eca21b5f9b9dd11a71b7a8e14dab70e"
    sha256 cellar: :any,                 arm64_sonoma:  "5086cd5702ad15af5b8c0d4508a799596eca21b5f9b9dd11a71b7a8e14dab70e"
    sha256 cellar: :any,                 arm64_ventura: "5086cd5702ad15af5b8c0d4508a799596eca21b5f9b9dd11a71b7a8e14dab70e"
    sha256                               sonoma:        "60e663bdae2db133843769c2206e67993d7fe7d56e6b157b3971514bf4d85aeb"
    sha256                               ventura:       "60e663bdae2db133843769c2206e67993d7fe7d56e6b157b3971514bf4d85aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f24a196683d353106f1497a135171b7cd98d7395c8a320165c942b858503bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d3800dd528f3b28b810f9d9c0f38b1b5ffa052add5ffc0687e01b40394197da"
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
