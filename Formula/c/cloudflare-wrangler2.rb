require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.13.1.tgz"
  sha256 "3e7469f899095d470101f30385713e2eec2da765d8dc2d0585237da6f4bf8194"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "597a01901d2d92926a193148030d6cf6ada7fecac0d66ea3a7cb922c16c97a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "597a01901d2d92926a193148030d6cf6ada7fecac0d66ea3a7cb922c16c97a3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "597a01901d2d92926a193148030d6cf6ada7fecac0d66ea3a7cb922c16c97a3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "79450a1c0194e573915bca514793056a46cfe3a205748635dc94ec6db42ee91c"
    sha256 cellar: :any_skip_relocation, ventura:        "79450a1c0194e573915bca514793056a46cfe3a205748635dc94ec6db42ee91c"
    sha256 cellar: :any_skip_relocation, monterey:       "79450a1c0194e573915bca514793056a46cfe3a205748635dc94ec6db42ee91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ab7a4fe2ca0ba2381ebb02d2d6c404c4bb93d890e122cb04ebe6577805b7d1"
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
