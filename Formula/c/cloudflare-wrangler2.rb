require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.29.0.tgz"
  sha256 "fd0430c2e40104c132b812e0a2f78c1ed9d0f9c06abdbcfd47ede8a23e4a4d1f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "347030ddbce099d4dedf72e145aa2ef9a23d796a8d5300bba7b3534e41b7324d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "347030ddbce099d4dedf72e145aa2ef9a23d796a8d5300bba7b3534e41b7324d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347030ddbce099d4dedf72e145aa2ef9a23d796a8d5300bba7b3534e41b7324d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b05c71172bd9bdd8dc6608d5863991b27f4ce7ca212ff1d1715a568f2e4a0565"
    sha256 cellar: :any_skip_relocation, ventura:        "b05c71172bd9bdd8dc6608d5863991b27f4ce7ca212ff1d1715a568f2e4a0565"
    sha256 cellar: :any_skip_relocation, monterey:       "b05c71172bd9bdd8dc6608d5863991b27f4ce7ca212ff1d1715a568f2e4a0565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e04d55599cc5ae20623f2cc7825187577aaef16f1e4151e32298132f872d8d"
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
