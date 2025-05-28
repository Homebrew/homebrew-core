class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.17.0.tgz"
  sha256 "98cfc28d1bdb3d5bfe8bcbe583ecdd2d5bb82ed04ec51fdaacde884ee09c81d8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "339f644e9797291a077f8c0f5fd0d65e3d28f44262bc96f23c36c933b88216a0"
    sha256 cellar: :any,                 arm64_sonoma:  "339f644e9797291a077f8c0f5fd0d65e3d28f44262bc96f23c36c933b88216a0"
    sha256 cellar: :any,                 arm64_ventura: "339f644e9797291a077f8c0f5fd0d65e3d28f44262bc96f23c36c933b88216a0"
    sha256                               sonoma:        "3d979d9e2aa48f9f4f8b6ac3ebaabd6bd38d2a91033b6499f6eb717e02095a42"
    sha256                               ventura:       "3d979d9e2aa48f9f4f8b6ac3ebaabd6bd38d2a91033b6499f6eb717e02095a42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a3a14d366173b5825c387b2bbafea4711b743931b8b11037dc498d9ecb2bfcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76649b510dfacf6007bd1863177e5b8e3262a43466047cac4eb15c2ced7ea3ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
