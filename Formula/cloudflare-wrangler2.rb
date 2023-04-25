require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.17.0.tgz"
  sha256 "1d7f2e2c476145dd042c756a28b778a9616a3372e2002daed35e4b1d41c90fa9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b769d49d1d7b9bdf96ed865c978a51384f1652ed59f79ded16acb9a982cc3020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b769d49d1d7b9bdf96ed865c978a51384f1652ed59f79ded16acb9a982cc3020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b769d49d1d7b9bdf96ed865c978a51384f1652ed59f79ded16acb9a982cc3020"
    sha256 cellar: :any_skip_relocation, ventura:        "4f7e109de3f40001774327db2a27b067de8207ed7f34654ec9d4a8c4c28a2c7f"
    sha256 cellar: :any_skip_relocation, monterey:       "4f7e109de3f40001774327db2a27b067de8207ed7f34654ec9d4a8c4c28a2c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f7e109de3f40001774327db2a27b067de8207ed7f34654ec9d4a8c4c28a2c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541821a29c094037949e5488522f25bd43a8e4e4f4b46e2fa0dea1ddadd38573"
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
