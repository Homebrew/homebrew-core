require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.34.2.tgz"
  sha256 "7631badd6ddbd7004824fa4cc86d3297852ff087acd279ed028d90cac28b3a97"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f3a5d4fb539de64892369760c223b3ce308d244b616310c24b46d07259a4b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f3a5d4fb539de64892369760c223b3ce308d244b616310c24b46d07259a4b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f3a5d4fb539de64892369760c223b3ce308d244b616310c24b46d07259a4b67"
    sha256 cellar: :any_skip_relocation, sonoma:         "a17c31191be4a736e45aa368104cc822280dc2bac65767042c9906d0500f90ac"
    sha256 cellar: :any_skip_relocation, ventura:        "a17c31191be4a736e45aa368104cc822280dc2bac65767042c9906d0500f90ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a17c31191be4a736e45aa368104cc822280dc2bac65767042c9906d0500f90ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135198e6bc9c667353107f9a0d41ffc53ddfc58c0ba61ec24c7789bef2c28711"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
