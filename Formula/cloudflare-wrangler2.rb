require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.12.1.tgz"
  sha256 "61b973ad812ea434e57f0d7d7e4c51345e317e04028aa116ce0df5d01e80970c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb88cd1c7cd31cc1820bcd1f5f8268acac79fdef68ac2f16a8354344891351f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb88cd1c7cd31cc1820bcd1f5f8268acac79fdef68ac2f16a8354344891351f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb88cd1c7cd31cc1820bcd1f5f8268acac79fdef68ac2f16a8354344891351f8"
    sha256 cellar: :any_skip_relocation, ventura:        "f4d77dddf1ab9afc6bb75e6d2fd8f91ce086e1ba1bd67fd8ff4702a2bb363ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "f4d77dddf1ab9afc6bb75e6d2fd8f91ce086e1ba1bd67fd8ff4702a2bb363ec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4d77dddf1ab9afc6bb75e6d2fd8f91ce086e1ba1bd67fd8ff4702a2bb363ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "863934470c0eb24873cf91c023d60a4e40f2e4b29610b28545502d92c762a4a5"
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
