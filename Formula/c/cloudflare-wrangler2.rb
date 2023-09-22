require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.9.0.tgz"
  sha256 "aa8128c74b28e7b9f4e321f9e913ff39246b13612c7849f605b21d87dfe9348e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f217a07e280569df0d4a532ac61955a998237927d97c17def892882b23a9eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f217a07e280569df0d4a532ac61955a998237927d97c17def892882b23a9eb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f217a07e280569df0d4a532ac61955a998237927d97c17def892882b23a9eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "7489336f1b3cab046a40613990d199d7ea9491d07d428d104f2c0134feb36934"
    sha256 cellar: :any_skip_relocation, monterey:       "7489336f1b3cab046a40613990d199d7ea9491d07d428d104f2c0134feb36934"
    sha256 cellar: :any_skip_relocation, big_sur:        "7489336f1b3cab046a40613990d199d7ea9491d07d428d104f2c0134feb36934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64bcbb3ca67a53fb259bf5d983e1d846824e8bc0e4b304e195ba38f72836f702"
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
