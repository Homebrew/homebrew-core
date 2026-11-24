class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.167.0.tgz"
  sha256 "ecbe4447a9d8da3b0f77dbf4249df7a4b88a11c9aca3ade97829581c96409126"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    manifest_sha256 "9863c0fdc2c736b9ad17da3babccc329d7fd77a698530694951e244810f8878e"
    sha256 cellar: :any, arm64_golden_gate: "3f149494f7b4f9210fd4a10d4d6cb431b094e0af378553e21d8c2786ca900017"
    sha256 cellar: :any, arm64_tahoe:       "3f149494f7b4f9210fd4a10d4d6cb431b094e0af378553e21d8c2786ca900017"
    sha256 cellar: :any, arm64_sequoia:     "3f149494f7b4f9210fd4a10d4d6cb431b094e0af378553e21d8c2786ca900017"
    sha256 cellar: :any, arm64_linux:       "3d71dea20730d7d128a97b21204e5f0f92c14e631d3711fb6aa06cd089459d83"
    sha256 cellar: :any, x86_64_linux:      "59d19719a8c78693e9784e29eae66d64f822444d40a6a37bb97d38bc76d0f2f3"
  end

  depends_on "node"

  allow_network_access! :build

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
