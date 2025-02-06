class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.107.3.tgz"
  sha256 "a109dfe88804f8d11946153f9d50838f203285b9fd99c79baa5e2dc848fc4d04"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b414d2c103af5fe08d763087a2e8a7a2f4a9abe2228c53d1634e0014fa711516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b414d2c103af5fe08d763087a2e8a7a2f4a9abe2228c53d1634e0014fa711516"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b414d2c103af5fe08d763087a2e8a7a2f4a9abe2228c53d1634e0014fa711516"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c8923080eb2f8cca0570fa23c57d90f52264d1d175e46a54ebe69df2dd6aed"
    sha256 cellar: :any_skip_relocation, ventura:       "18c8923080eb2f8cca0570fa23c57d90f52264d1d175e46a54ebe69df2dd6aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d43623c46cc0d540d5ebb9109a4950a05e8ddb075b2f37a9b838ce0c0ba88b43"
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
