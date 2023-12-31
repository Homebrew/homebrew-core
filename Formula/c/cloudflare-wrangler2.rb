require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.22.1.tgz"
  sha256 "838d9f8cba8619e840e0a03ca5ff61e09b88bcd7f84bbceacf7e9756bc477db5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de95717c968a122749a7022e2d7a98d0d7494139645760339b253bc932577c34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de95717c968a122749a7022e2d7a98d0d7494139645760339b253bc932577c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de95717c968a122749a7022e2d7a98d0d7494139645760339b253bc932577c34"
    sha256 cellar: :any_skip_relocation, sonoma:         "0176dc829cbc4f4811efb67fc79e17e804af500965abc24f1e56a0d0eb49406b"
    sha256 cellar: :any_skip_relocation, ventura:        "0176dc829cbc4f4811efb67fc79e17e804af500965abc24f1e56a0d0eb49406b"
    sha256 cellar: :any_skip_relocation, monterey:       "0176dc829cbc4f4811efb67fc79e17e804af500965abc24f1e56a0d0eb49406b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235930755dcdcf441d0f9d4f405a63b8cde75c0c85cdee581836cbba76bcc7bf"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
