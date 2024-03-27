require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.39.0.tgz"
  sha256 "b9df6e7a0b8dbe194ef1db2bc64c90fb28c73b393c32d88de4a2736a3bb89c2d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0092bf0a49256f68cb284b44a4db4e194e622c30e25a8100a498722ed849c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee0092bf0a49256f68cb284b44a4db4e194e622c30e25a8100a498722ed849c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0092bf0a49256f68cb284b44a4db4e194e622c30e25a8100a498722ed849c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "6072305ddc2f124f19ee3ef37559338d976f3d3c7e23248c35864ffcf6b012c9"
    sha256 cellar: :any_skip_relocation, ventura:        "6072305ddc2f124f19ee3ef37559338d976f3d3c7e23248c35864ffcf6b012c9"
    sha256 cellar: :any_skip_relocation, monterey:       "6072305ddc2f124f19ee3ef37559338d976f3d3c7e23248c35864ffcf6b012c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e1cfdda0f0592be93685b5140e29056783726f0fd108d713f7937e4463a0a5"
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
