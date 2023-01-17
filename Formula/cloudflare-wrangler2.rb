require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.8.0.tgz"
  sha256 "d66bda5aa29013a95d2753c883b5677ef4aed41cea620a6767650364da6957d2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ff5f6f86468ce67a4f586a61fe7da7822c55ef9f52ebd1f7e47b99ef88fa36e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff5f6f86468ce67a4f586a61fe7da7822c55ef9f52ebd1f7e47b99ef88fa36e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ff5f6f86468ce67a4f586a61fe7da7822c55ef9f52ebd1f7e47b99ef88fa36e"
    sha256 cellar: :any_skip_relocation, ventura:        "1a06fc11aae046e11d82a34258e2ee3acfb104423b28f1e4dad90889ae28e1ba"
    sha256 cellar: :any_skip_relocation, monterey:       "1a06fc11aae046e11d82a34258e2ee3acfb104423b28f1e4dad90889ae28e1ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a06fc11aae046e11d82a34258e2ee3acfb104423b28f1e4dad90889ae28e1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00173c948d312f3497e5fc6e2d17db49169e1dd9b81be2f237197af3b50752bc"
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
