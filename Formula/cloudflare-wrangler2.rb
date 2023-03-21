require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.13.0.tgz"
  sha256 "ffaff80acd44b1be837d0bd0b418fe55ad4188e01bda9ddda7079dda41f9e662"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b63b49069a89b6b49d3b753c71f229e2a1fec888ba2bb79eb65033b243097b3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b63b49069a89b6b49d3b753c71f229e2a1fec888ba2bb79eb65033b243097b3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b63b49069a89b6b49d3b753c71f229e2a1fec888ba2bb79eb65033b243097b3c"
    sha256 cellar: :any_skip_relocation, ventura:        "0370f761c637e6abff5b9b37c217b092c6d5226f48dfce0b7a434e723c183cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "0370f761c637e6abff5b9b37c217b092c6d5226f48dfce0b7a434e723c183cc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0370f761c637e6abff5b9b37c217b092c6d5226f48dfce0b7a434e723c183cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b7ee04dbafb933b92bd494cc67e8b8568ab7773c8d36ea61da27df1c3181c8"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    system "#{bin}/wrangler", "init", "--yes"
    assert_predicate testpath/"wrangler.toml", :exist?
    assert_match "wrangler", (testpath/"package.json").read

    assert_match "dry-run: exiting now.", shell_output("#{bin}/wrangler publish --dry-run")
  end
end
