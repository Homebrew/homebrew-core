require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.33.0.tgz"
  sha256 "8664f5995b6e8959e28f0e63139269fe6e390ccf7e87fcf3ed13b369d7386747"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cf2da4176c0fd4580e5a66bf9d58dc5b74b42cc9310e1412c02f5da3b6d0ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cf2da4176c0fd4580e5a66bf9d58dc5b74b42cc9310e1412c02f5da3b6d0ab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf2da4176c0fd4580e5a66bf9d58dc5b74b42cc9310e1412c02f5da3b6d0ab3"
    sha256 cellar: :any_skip_relocation, sonoma:         "50b2cfed0d620c681065857667c2a31cfa4b0a7b184be4bb7c034a856951176e"
    sha256 cellar: :any_skip_relocation, ventura:        "50b2cfed0d620c681065857667c2a31cfa4b0a7b184be4bb7c034a856951176e"
    sha256 cellar: :any_skip_relocation, monterey:       "50b2cfed0d620c681065857667c2a31cfa4b0a7b184be4bb7c034a856951176e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9f0f695e371cfd2b1b1fcbfdb52700b240b0cfb3a0f92d5d15dea0694a183ce"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
