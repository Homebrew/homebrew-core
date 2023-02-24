require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.11.1.tgz"
  sha256 "9372127826365a2dfe8696e41de822deb9d5f4ca458c3da79a90153599b7d639"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a45600f9a50d1baab4562c3b48a5c826b1f36d35f3150107e07e82fd83d9e2c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a45600f9a50d1baab4562c3b48a5c826b1f36d35f3150107e07e82fd83d9e2c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a45600f9a50d1baab4562c3b48a5c826b1f36d35f3150107e07e82fd83d9e2c1"
    sha256 cellar: :any_skip_relocation, ventura:        "674d2b021959564c892da6a52c3574da3ef0ac905055d097916bcabbed72074c"
    sha256 cellar: :any_skip_relocation, monterey:       "674d2b021959564c892da6a52c3574da3ef0ac905055d097916bcabbed72074c"
    sha256 cellar: :any_skip_relocation, big_sur:        "674d2b021959564c892da6a52c3574da3ef0ac905055d097916bcabbed72074c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ddbc5e435dcb95246996d2aa4c71799016d1bc287eda7a2f0d5270695f6b7a"
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
