class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.163.0.tgz"
  sha256 "cf53c3dc3ac499e1a24ae841bca0d39b668b907ca94add51f2d59592853eabb2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec247d59384c0478eaaa8d574fb09c9a5aa3d90ad2ea98ac6563fac42975fb5c"
    sha256 cellar: :any, arm64_tahoe:       "ec247d59384c0478eaaa8d574fb09c9a5aa3d90ad2ea98ac6563fac42975fb5c"
    sha256 cellar: :any, arm64_sequoia:     "ec247d59384c0478eaaa8d574fb09c9a5aa3d90ad2ea98ac6563fac42975fb5c"
    sha256 cellar: :any, arm64_linux:       "eb9b152200f9bb4ecbe6668e52db2ea517aaee9b2dfcf05f0f6795d8fb672a64"
    sha256 cellar: :any, x86_64_linux:      "6c1fee801317ae25c129ae748f1f6dd5c3280bbb3d551372cad0b45a31731bb9"
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
