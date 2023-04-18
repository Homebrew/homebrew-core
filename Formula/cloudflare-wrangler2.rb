require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.16.0.tgz"
  sha256 "bcd972361f95e06acf0dc30caf59204db40f0615ca8dc6d7bdec02b5ea6d3400"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a009001e4bc780812218f7d8e1b3ac7e45187818fd4ce2149c63a5e3eb9064d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a009001e4bc780812218f7d8e1b3ac7e45187818fd4ce2149c63a5e3eb9064d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a009001e4bc780812218f7d8e1b3ac7e45187818fd4ce2149c63a5e3eb9064d"
    sha256 cellar: :any_skip_relocation, ventura:        "d92fa1872ca680ab7ebe03ae16dd12decc15711d6ad463121e104ed79aa6fcec"
    sha256 cellar: :any_skip_relocation, monterey:       "d92fa1872ca680ab7ebe03ae16dd12decc15711d6ad463121e104ed79aa6fcec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d92fa1872ca680ab7ebe03ae16dd12decc15711d6ad463121e104ed79aa6fcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed00959de8e55393a74bc670ea2f6ea2950ba94cb0743d7f9962720cc7b1c5b5"
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
