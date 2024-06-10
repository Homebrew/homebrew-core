require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.60.0.tgz"
  sha256 "5c6e19025653b491c2e52b4c01a3e8e13337d989cea9e40a8e1b9247e5f03485"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aacdb8889134284f56c809d1c126567091220e9bf4e4435b4011667532dc9ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aacdb8889134284f56c809d1c126567091220e9bf4e4435b4011667532dc9ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aacdb8889134284f56c809d1c126567091220e9bf4e4435b4011667532dc9ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "f37f2a41021de83c858522d61d60a27563c8c3020bf32f489ba765e697c463e8"
    sha256 cellar: :any_skip_relocation, ventura:        "f37f2a41021de83c858522d61d60a27563c8c3020bf32f489ba765e697c463e8"
    sha256 cellar: :any_skip_relocation, monterey:       "f37f2a41021de83c858522d61d60a27563c8c3020bf32f489ba765e697c463e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79be95456aaac12146e4e49335abadf153fc7d435bfc57b2efca624f6eec093"
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
