require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.32.0.tgz"
  sha256 "6ca792f586fd31a74187b8c83b6729b16ca2cd668d7ba8ff09ee9de4e5c254af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f49fa647748e495255b856a30b268cac7a8b5605371738992d0d1cdbb2013dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f49fa647748e495255b856a30b268cac7a8b5605371738992d0d1cdbb2013dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f49fa647748e495255b856a30b268cac7a8b5605371738992d0d1cdbb2013dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5936d740be8a039c360cd9c8f789bff75081d13dc8203d63f4fc3e5d7f0f9377"
    sha256 cellar: :any_skip_relocation, ventura:        "5936d740be8a039c360cd9c8f789bff75081d13dc8203d63f4fc3e5d7f0f9377"
    sha256 cellar: :any_skip_relocation, monterey:       "5936d740be8a039c360cd9c8f789bff75081d13dc8203d63f4fc3e5d7f0f9377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a30b536eef0a42a160ba1634784e66eaed2e91c42a7e50984e7c9b9ae235c092"
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
