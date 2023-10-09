require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.11.0.tgz"
  sha256 "609028655bb802111bf4d58e3586d60174a658f4f6351d4d3e8bf3752b438416"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8284292308c9d706779ca0a720f885f074bef65462b7692f5aee36f66fb111e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8284292308c9d706779ca0a720f885f074bef65462b7692f5aee36f66fb111e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8284292308c9d706779ca0a720f885f074bef65462b7692f5aee36f66fb111e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b663070d22885cec399b06a2a18d305fc52ada53f7c86a4819a80617bd0c9d0a"
    sha256 cellar: :any_skip_relocation, ventura:        "b663070d22885cec399b06a2a18d305fc52ada53f7c86a4819a80617bd0c9d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "b663070d22885cec399b06a2a18d305fc52ada53f7c86a4819a80617bd0c9d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ec53ccf9d1c5986428d15a51977c299af1da84fa177401c8af148dd81fbadf"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
