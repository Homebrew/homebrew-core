require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.14.0.tgz"
  sha256 "387c3ea275f3c11955ac616acac4bd78a8e6e05ceb83d1e356a8049ee1fbeaea"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "636b4a58555d738c01d21305c57aae0d85ab648c055f336041d36029506bd51f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "636b4a58555d738c01d21305c57aae0d85ab648c055f336041d36029506bd51f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "636b4a58555d738c01d21305c57aae0d85ab648c055f336041d36029506bd51f"
    sha256 cellar: :any_skip_relocation, sonoma:         "eabfd58a47a1ed4b57be541ed16a2ba25e3f606980e369d1ef4e84c73f5bc51d"
    sha256 cellar: :any_skip_relocation, ventura:        "eabfd58a47a1ed4b57be541ed16a2ba25e3f606980e369d1ef4e84c73f5bc51d"
    sha256 cellar: :any_skip_relocation, monterey:       "eabfd58a47a1ed4b57be541ed16a2ba25e3f606980e369d1ef4e84c73f5bc51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a228e3c5a14cd9803553a32ac83eaa252f7b5d3ab92ebd27114812af6d616d7"
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
