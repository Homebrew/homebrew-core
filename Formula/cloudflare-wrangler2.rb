require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.9.0.tgz"
  sha256 "651eab30ec0cb38034efcd8dbf0c8576ea7b537c024510accaff2bcadecc74fd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0676038a933a4c9a5f85e01c1cb11bd2e1e5266da044387e9169002178ec8d18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0676038a933a4c9a5f85e01c1cb11bd2e1e5266da044387e9169002178ec8d18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0676038a933a4c9a5f85e01c1cb11bd2e1e5266da044387e9169002178ec8d18"
    sha256 cellar: :any_skip_relocation, ventura:        "7539f19f83ad3f18383bcf7793fbf5cb3ed1424122a13d3c425e9f8070b1bcb9"
    sha256 cellar: :any_skip_relocation, monterey:       "7539f19f83ad3f18383bcf7793fbf5cb3ed1424122a13d3c425e9f8070b1bcb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7539f19f83ad3f18383bcf7793fbf5cb3ed1424122a13d3c425e9f8070b1bcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56eb506524fef907688792a044282f210df6f2a5f031dfd23e4b59a281a40c0c"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/wrangler/node_modules/fsevents/fsevents.node"
  end

  test do
    system "#{bin}/wrangler", "init", "--yes"
    assert_predicate testpath/"wrangler.toml", :exist?
    assert_match "wrangler", (testpath/"package.json").read

    assert_match "dry-run: exiting now.", shell_output("#{bin}/wrangler publish --dry-run")
  end
end
