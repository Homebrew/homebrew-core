require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.7.1.tgz"
  sha256 "89e4c56174f86aa66b90f942b1a5bf994560658fd80c70947db2545153df16ce"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf6150f975b3b927a47ce75aa807639e6010b9c7306cb336dd4d32d23a54d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bf6150f975b3b927a47ce75aa807639e6010b9c7306cb336dd4d32d23a54d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bf6150f975b3b927a47ce75aa807639e6010b9c7306cb336dd4d32d23a54d31"
    sha256 cellar: :any_skip_relocation, ventura:        "588d9dfd7de3ff98c28f3adfa7bf6f3f4cfda1f9109d991f2e2e62cd1e6f713f"
    sha256 cellar: :any_skip_relocation, monterey:       "588d9dfd7de3ff98c28f3adfa7bf6f3f4cfda1f9109d991f2e2e62cd1e6f713f"
    sha256 cellar: :any_skip_relocation, big_sur:        "588d9dfd7de3ff98c28f3adfa7bf6f3f4cfda1f9109d991f2e2e62cd1e6f713f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284939e9af88517ff7d7bd2388bc5e081f416d2b136f4f1e37aff62865336ab6"
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
