class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.151.2.tgz"
  sha256 "0af1b741dd6df51d4d059dd97c76e6e03631bbb609a2c3eb6a3bf845f5aab7d4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab53b76289d099b27b81c346d1406fda977de69bf6434664a14b2afb95918557"
    sha256 cellar: :any, arm64_tahoe:       "ab53b76289d099b27b81c346d1406fda977de69bf6434664a14b2afb95918557"
    sha256 cellar: :any, arm64_sequoia:     "ab53b76289d099b27b81c346d1406fda977de69bf6434664a14b2afb95918557"
    sha256 cellar: :any, arm64_linux:       "06f0526feb53a79d214286d4f015130ce116399105cc15b99bb3d2032bb8bef9"
    sha256 cellar: :any, x86_64_linux:      "50acc53a31697a46123e565be709561cd4bae11e91ceb2f84fe712175a7fdf4e"
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
