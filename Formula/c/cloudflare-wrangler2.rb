require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.36.0.tgz"
  sha256 "ee11b3aa5fa0ddf03ee350d9a6cb027ec9f3a56584dc117238d3c44bbe3d7d80"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed55d7d43aa897cb97791f913a9d677cf02e36f8de0d6514faa1ac71f0492a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ed55d7d43aa897cb97791f913a9d677cf02e36f8de0d6514faa1ac71f0492a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed55d7d43aa897cb97791f913a9d677cf02e36f8de0d6514faa1ac71f0492a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "49edc5846cc0943410c05e9e84b6fc49272225416fb51024d673de0dfff0f652"
    sha256 cellar: :any_skip_relocation, ventura:        "49edc5846cc0943410c05e9e84b6fc49272225416fb51024d673de0dfff0f652"
    sha256 cellar: :any_skip_relocation, monterey:       "49edc5846cc0943410c05e9e84b6fc49272225416fb51024d673de0dfff0f652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "046467bcb343cb0e7702527a0cefc905e462dffa93f1155ce69b4e8e6d252d09"
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
