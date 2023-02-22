require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.11.0.tgz"
  sha256 "9c89e4f61802de7426be2c77395bfa30b9088c958e79da630d9b25cf36b78d8d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eba0dbed77c51cbc05a2deb344233773644fe7a063e66db32c3b81773f1f6e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eba0dbed77c51cbc05a2deb344233773644fe7a063e66db32c3b81773f1f6e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eba0dbed77c51cbc05a2deb344233773644fe7a063e66db32c3b81773f1f6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "2bcbd07721002092e8d7631842d66abbb9b8b035d575f1837637ea5f639ac367"
    sha256 cellar: :any_skip_relocation, monterey:       "2bcbd07721002092e8d7631842d66abbb9b8b035d575f1837637ea5f639ac367"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bcbd07721002092e8d7631842d66abbb9b8b035d575f1837637ea5f639ac367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3a076d3d6be855b0a6f766fa243359a5ea3531947194b98d87d926a775dd2c"
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
