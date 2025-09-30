class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.40.3.tgz"
  sha256 "aef15a250c13fa0cfeb6a20588299b46bc6ae2ab55fb47945e82e22e2b248116"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af8934f4968eef0656d40300014ea1ab8306596602196fc3aa5136e5db26990f"
    sha256 cellar: :any,                 arm64_sequoia: "94d0ec0269a75932ff6de661ad6f031d7a732b5c6aa677862773c62b37e26938"
    sha256 cellar: :any,                 arm64_sonoma:  "94d0ec0269a75932ff6de661ad6f031d7a732b5c6aa677862773c62b37e26938"
    sha256 cellar: :any,                 sonoma:        "e1fb602c34769d0202c7ebc3db6835ecb2dfa835db449f0d1512345ad054ce19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1143530ad3cc2234c84be18c7b9b630eede588814d41cc4eb23c372e0b21ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20021db314185faeb5cc0e3a89485e76d079b1a6649a3b5740a6516d3f8f5dd"
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
