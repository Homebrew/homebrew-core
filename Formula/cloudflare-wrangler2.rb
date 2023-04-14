require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.15.1.tgz"
  sha256 "916c9995530554b7479657076fe274d531cc99f9ebfc1c8fa0f8387abcf028fa"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c668b7c68fcced41f235b3325c271f2a7f617bce2af1a040424de5ebd9a7d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c668b7c68fcced41f235b3325c271f2a7f617bce2af1a040424de5ebd9a7d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c668b7c68fcced41f235b3325c271f2a7f617bce2af1a040424de5ebd9a7d65"
    sha256 cellar: :any_skip_relocation, ventura:        "da40fbe0490ff2d91e2b7b8b8ffc817ac1b05e8ec8091cc6bfe71d4c0d852ed4"
    sha256 cellar: :any_skip_relocation, monterey:       "da40fbe0490ff2d91e2b7b8b8ffc817ac1b05e8ec8091cc6bfe71d4c0d852ed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "da40fbe0490ff2d91e2b7b8b8ffc817ac1b05e8ec8091cc6bfe71d4c0d852ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e496025de235e30673aceadb8ae3b9036b4bddbd9f1806b2be053eb2296cc6e1"
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
