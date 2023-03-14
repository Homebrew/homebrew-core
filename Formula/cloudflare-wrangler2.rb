require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.12.3.tgz"
  sha256 "bc7e6a13c4c3573c28f03b28913a39397c793a1f48ba63bc344fe15f167c79a8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803ca4f878b06c6b9c18111cd70a1a24faf1fcffcaae352224043790792f9928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "803ca4f878b06c6b9c18111cd70a1a24faf1fcffcaae352224043790792f9928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803ca4f878b06c6b9c18111cd70a1a24faf1fcffcaae352224043790792f9928"
    sha256 cellar: :any_skip_relocation, ventura:        "f48f9c14dba8475d32355f73be49e2833c3fb9adf1577c271b1f9126cb85f304"
    sha256 cellar: :any_skip_relocation, monterey:       "f48f9c14dba8475d32355f73be49e2833c3fb9adf1577c271b1f9126cb85f304"
    sha256 cellar: :any_skip_relocation, big_sur:        "f48f9c14dba8475d32355f73be49e2833c3fb9adf1577c271b1f9126cb85f304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c6819ed36f08faf4aa37446744ec98cc0809cec388b748b85f67995fc2b38b"
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
