require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.31.0.tgz"
  sha256 "67341e283431a02126f981a895c8fabf03f2faba28ab229d613f6e788263f2ae"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7a7875dccfd0c41c6744daf39238039af84054f826f04dd3af4c9ddb0739fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7a7875dccfd0c41c6744daf39238039af84054f826f04dd3af4c9ddb0739fa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a7875dccfd0c41c6744daf39238039af84054f826f04dd3af4c9ddb0739fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "208fcfbf042465f79d2dc0e18966d42a812d0f9f58ef2e3a356adf15b84a2d87"
    sha256 cellar: :any_skip_relocation, ventura:        "208fcfbf042465f79d2dc0e18966d42a812d0f9f58ef2e3a356adf15b84a2d87"
    sha256 cellar: :any_skip_relocation, monterey:       "208fcfbf042465f79d2dc0e18966d42a812d0f9f58ef2e3a356adf15b84a2d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6cba00721c3a6f9dde7619c5d87d54b8c3f69c3a01d1aee1a475ca703d27b9c"
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
