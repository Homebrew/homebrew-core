require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.14.0.tgz"
  sha256 "20bc545557ff851417bedb9490e3b360f09da5448d5f56c6e67d309c7164abb8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2095376f006eb2f344dcbf911e381efbd2ca773a2da8b5b1cfb411e145c85d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2095376f006eb2f344dcbf911e381efbd2ca773a2da8b5b1cfb411e145c85d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2095376f006eb2f344dcbf911e381efbd2ca773a2da8b5b1cfb411e145c85d7"
    sha256 cellar: :any_skip_relocation, ventura:        "ebcc049e307359a5a3d56ad55ed31ea73302a6aa78034faa874e1ca02510f8e1"
    sha256 cellar: :any_skip_relocation, monterey:       "ebcc049e307359a5a3d56ad55ed31ea73302a6aa78034faa874e1ca02510f8e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebcc049e307359a5a3d56ad55ed31ea73302a6aa78034faa874e1ca02510f8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ec287aae8403c98d37e51e69ec021535c0404d2a119265c3662ccfe3981adee"
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
