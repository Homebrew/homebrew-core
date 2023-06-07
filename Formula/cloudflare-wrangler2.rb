require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.20.0.tgz"
  sha256 "3bd115747ae01700cd40ab869440785eb9de771ad946a591b65ec313783cea96"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5495721136e800f7cf2cea81dd308e55d1a96abf7dc935869f172e08c9c2f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5495721136e800f7cf2cea81dd308e55d1a96abf7dc935869f172e08c9c2f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa5495721136e800f7cf2cea81dd308e55d1a96abf7dc935869f172e08c9c2f8"
    sha256 cellar: :any_skip_relocation, ventura:        "2d6dc744a093ab258c27cacfe855d9114550455f8395897ab08b5ad4ae13f437"
    sha256 cellar: :any_skip_relocation, monterey:       "2d6dc744a093ab258c27cacfe855d9114550455f8395897ab08b5ad4ae13f437"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d6dc744a093ab258c27cacfe855d9114550455f8395897ab08b5ad4ae13f437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac9a6524b0e39612cfeebd8bce775911f211411ca80628573c03c2eece05c9a"
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
