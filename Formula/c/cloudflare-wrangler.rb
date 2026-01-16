class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.59.2.tgz"
  sha256 "628949a00a92af38a1625fea55eeb73154080a28dc474924162d882797d5a0a7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45232f8108f497c650005cd00022564126bf91b2e710070e5e8b2f0817a0d30f"
    sha256 cellar: :any,                 arm64_sequoia: "8ecf474d86a44b44afbc38fe32e2c167badc0199ee62a1e13c4e995915e07a96"
    sha256 cellar: :any,                 arm64_sonoma:  "8ecf474d86a44b44afbc38fe32e2c167badc0199ee62a1e13c4e995915e07a96"
    sha256 cellar: :any,                 sonoma:        "6a374438194ee6d3fa24271200e2e41e3eaba548e1b75432cf6ea9644c711656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38cd5f48ffb8c7aa7838247949a1c4bdd8760f1dd178541db85577b12ff0d243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba489e038e6e9817685698ac6038c301820baafd5066e697e0433073e635320a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
