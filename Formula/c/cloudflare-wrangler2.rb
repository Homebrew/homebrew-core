require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.60.3.tgz"
  sha256 "f43573b7b844a0c2f62a426169b087c25574c5c871b6a219e7b86e6628491dc5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db09f717a3ec77d8368cb1245c7d5bdcd53cda1705b50015c14f563c8bf9d6ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db09f717a3ec77d8368cb1245c7d5bdcd53cda1705b50015c14f563c8bf9d6ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db09f717a3ec77d8368cb1245c7d5bdcd53cda1705b50015c14f563c8bf9d6ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "74932e63578d43087317a73fbfdbcf57c4bc0b73a33d32448410206d018bff9d"
    sha256 cellar: :any_skip_relocation, ventura:        "74932e63578d43087317a73fbfdbcf57c4bc0b73a33d32448410206d018bff9d"
    sha256 cellar: :any_skip_relocation, monterey:       "74932e63578d43087317a73fbfdbcf57c4bc0b73a33d32448410206d018bff9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceece8e0f43ca92d7f2488cae1b11ac2b7106670bad5efc5b065d62e22684fc6"
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
