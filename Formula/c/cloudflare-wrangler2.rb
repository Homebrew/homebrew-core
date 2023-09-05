require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.6.0.tgz"
  sha256 "9f34c88fcc80a8ede596a6775371b1dbeec12ab73820328cdd59c028bf4e4b18"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30dc4497df8c60c6ad076a7a50fbd6b624b1add8fd6bb60f1bf9091c15953dc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64fb2e24abb22e68c5aa262a177f6a4938bb20475348fb07dbc3ada391ce4ff4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f01a6b5fce97ac738bf0960289f64a57b89c15c92349a776b08f92129ba1dde6"
    sha256 cellar: :any_skip_relocation, ventura:        "03f6e4c97714b6802ef191a0b83d3bfbb4dcab66830707ca3acb37cafe9e5741"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c48783607d6a046c36e1790b4ed1c9ec86284dc084389dd1dd11f726751a51"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a93ef11bf8da4af83dfddd6800b1bd202ecce5dfdda497d8923927ba3e48fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1bf7ba3b98975c0ad17e052de57950b67bd5ecfbb63aca5508102a0e897ed3c"
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
