require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.50.0.tgz"
  sha256 "9cdd61862facf662427a9a95b2d4a54d542cc47ebef8b0ba32cfae049c5dee8f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e5321027f2b3bab65e268ca782f5526f7a1cc9e8d9544332e1b3f089dbcc058"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e5321027f2b3bab65e268ca782f5526f7a1cc9e8d9544332e1b3f089dbcc058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e5321027f2b3bab65e268ca782f5526f7a1cc9e8d9544332e1b3f089dbcc058"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cad0623def482a641ea77341603b3473842f0530775a466785dcb7d2a1da5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "6cad0623def482a641ea77341603b3473842f0530775a466785dcb7d2a1da5b9"
    sha256 cellar: :any_skip_relocation, monterey:       "6cad0623def482a641ea77341603b3473842f0530775a466785dcb7d2a1da5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf630dd2b0b38555c1ae6b0d02251f896bcd989ce5b1ee331dad0dd3e6312f6"
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
