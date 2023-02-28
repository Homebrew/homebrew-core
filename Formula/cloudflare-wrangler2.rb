require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.12.0.tgz"
  sha256 "dc6fc5e6f46096e4dd388f9202db561df93a45a42abbd9978c261bdc407b38b6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17252136dd36383c9df79a0b76743232060dfa63b856ecb9306004146084cda5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17252136dd36383c9df79a0b76743232060dfa63b856ecb9306004146084cda5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17252136dd36383c9df79a0b76743232060dfa63b856ecb9306004146084cda5"
    sha256 cellar: :any_skip_relocation, ventura:        "0d85bea6def9a68787ded7a1394d1c0174191150a8630da23b6301d5d3fc2d8a"
    sha256 cellar: :any_skip_relocation, monterey:       "0d85bea6def9a68787ded7a1394d1c0174191150a8630da23b6301d5d3fc2d8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d85bea6def9a68787ded7a1394d1c0174191150a8630da23b6301d5d3fc2d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a56a1c9016b038080f6be92b6dfc8f117e2ffb2366ad1fb77531eb80ca90997"
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
