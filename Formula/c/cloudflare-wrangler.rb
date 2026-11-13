class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.161.0.tgz"
  sha256 "60e778b3469468bb17cad4add9ef41245b6f13942fa3b94a420ff9c49a00cb7a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ee2bc4033540547f592c269e29627dd3e1154c6fce5ed7e8b564d3959e1f735"
    sha256 cellar: :any, arm64_tahoe:       "0ee2bc4033540547f592c269e29627dd3e1154c6fce5ed7e8b564d3959e1f735"
    sha256 cellar: :any, arm64_sequoia:     "0ee2bc4033540547f592c269e29627dd3e1154c6fce5ed7e8b564d3959e1f735"
    sha256 cellar: :any, arm64_linux:       "6192a042cb58bc542ed15c388a32d511d15932f7955e2ff8fb987fb0199b3f47"
    sha256 cellar: :any, x86_64_linux:      "9b7ce3f57598baa7501d97cb4b620f2debdb3dd00d2e9bcb53e6055646dc8ae6"
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
