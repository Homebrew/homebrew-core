require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.12.0.tgz"
  sha256 "3022bf74d15fa9a8ed5cbd8f5274111deb8311b5d6a3219528e95f80c5b45a8d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb4e5da25ed13d51e2b3df0eea41b8100610565d9a23d3f35cd3edfb299cb2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb4e5da25ed13d51e2b3df0eea41b8100610565d9a23d3f35cd3edfb299cb2e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb4e5da25ed13d51e2b3df0eea41b8100610565d9a23d3f35cd3edfb299cb2e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "80496233c93fb54917948d63f6dbd5d777363d5dffff3dc7d55c2805ea3756c7"
    sha256 cellar: :any_skip_relocation, ventura:        "80496233c93fb54917948d63f6dbd5d777363d5dffff3dc7d55c2805ea3756c7"
    sha256 cellar: :any_skip_relocation, monterey:       "80496233c93fb54917948d63f6dbd5d777363d5dffff3dc7d55c2805ea3756c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038c32074d5b7b2552512f6221e51343dc287f76096d918d18189bb6864d9f95"
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
