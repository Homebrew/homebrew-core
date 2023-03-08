require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.12.2.tgz"
  sha256 "de505b7d17fb8a8220ebb95f685bc99187b48bd3e49ff797a6673eb3d1a728dc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c82f52a9f69dc686505a4a46cd6b7e408f24e9e451e2e022a06619f3676ff4c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c82f52a9f69dc686505a4a46cd6b7e408f24e9e451e2e022a06619f3676ff4c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c82f52a9f69dc686505a4a46cd6b7e408f24e9e451e2e022a06619f3676ff4c9"
    sha256 cellar: :any_skip_relocation, ventura:        "37173b5569ebb4280ed859daf24865c1b518a650e273fe3646e296afbb8ee1da"
    sha256 cellar: :any_skip_relocation, monterey:       "37173b5569ebb4280ed859daf24865c1b518a650e273fe3646e296afbb8ee1da"
    sha256 cellar: :any_skip_relocation, big_sur:        "37173b5569ebb4280ed859daf24865c1b518a650e273fe3646e296afbb8ee1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0f63db120b2628ce75e9a73b2172f11e505e6950ac10c3bb43d2ba851f74d10"
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
