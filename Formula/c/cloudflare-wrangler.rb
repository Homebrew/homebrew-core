class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.159.0.tgz"
  sha256 "89305f945a3907118624468d1b735c967cc12ab09a98c02872ba3a9675bc0f32"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2abaee6730eb3cc0ef63b8261e923e374d8d515b1406ec8cc5309606e5dba629"
    sha256 cellar: :any, arm64_tahoe:       "2abaee6730eb3cc0ef63b8261e923e374d8d515b1406ec8cc5309606e5dba629"
    sha256 cellar: :any, arm64_sequoia:     "2abaee6730eb3cc0ef63b8261e923e374d8d515b1406ec8cc5309606e5dba629"
    sha256 cellar: :any, arm64_linux:       "f079231aee9593e269151cb9c258dd6587e8008ceafb5b8d92d04ff446463059"
    sha256 cellar: :any, x86_64_linux:      "ba5044d3f0dc670f31531cf75e96da184cf59f467ff857ed7aae317bfa811e86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
