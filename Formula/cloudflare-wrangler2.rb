require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.8.1.tgz"
  sha256 "5af64fac8c06450258b143191ac8957565395187bf173775665f83d5d8ff4c4f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c8674947cb14528816121a864b5bd43a6db37dec08d3ce530ec7635fc65746f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c8674947cb14528816121a864b5bd43a6db37dec08d3ce530ec7635fc65746f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c8674947cb14528816121a864b5bd43a6db37dec08d3ce530ec7635fc65746f"
    sha256 cellar: :any_skip_relocation, ventura:        "a55db6dd4d83ba25dfefc2bdd0cf2b122b4083f90df15d2e310c16d609dbacce"
    sha256 cellar: :any_skip_relocation, monterey:       "a55db6dd4d83ba25dfefc2bdd0cf2b122b4083f90df15d2e310c16d609dbacce"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55db6dd4d83ba25dfefc2bdd0cf2b122b4083f90df15d2e310c16d609dbacce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1aae6440e4ddaf8a96e90a730080e516c8197abb9aeb4bf839a5f6c4099c45f"
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
