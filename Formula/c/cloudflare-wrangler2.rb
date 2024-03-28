require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.39.0.tgz"
  sha256 "b9df6e7a0b8dbe194ef1db2bc64c90fb28c73b393c32d88de4a2736a3bb89c2d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5a212fe4baa59baff557ce40fb02c4bdfc0cc4423758820ad5b8ad1f94e1fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5a212fe4baa59baff557ce40fb02c4bdfc0cc4423758820ad5b8ad1f94e1fdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a212fe4baa59baff557ce40fb02c4bdfc0cc4423758820ad5b8ad1f94e1fdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4cf594c2827e44b6c1ce77927a9a36d177414335ba97dd4f008dcdc7295e6be"
    sha256 cellar: :any_skip_relocation, ventura:        "c4cf594c2827e44b6c1ce77927a9a36d177414335ba97dd4f008dcdc7295e6be"
    sha256 cellar: :any_skip_relocation, monterey:       "c4cf594c2827e44b6c1ce77927a9a36d177414335ba97dd4f008dcdc7295e6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c435a19cf2b9d5b3dc6a5876c3c9e831f9547b00227249ce812335a60c369826"
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
