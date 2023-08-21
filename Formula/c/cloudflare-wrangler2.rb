require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.5.1.tgz"
  sha256 "9c73ca8c5e2f90351081bb8f83fe27089bbede94ccc75b97bdebe0f1c36cfc72"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10368ee147136fcd1e3bbb89b1f5c0ce2e74f682299d43ddc6ebc24d031ffd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c5da71b9fb49ab7bf91f9114a113855188f5dc77be30a7764ad2dbc2de8bd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed78fb383059b9f04f13e91ca1b962089caff598711881246796ac8bce855c01"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf1d29491e5c77165108fab551d76e7649d234c8872b6c9c13e1340725fadad"
    sha256 cellar: :any_skip_relocation, monterey:       "dd1e7ae7dce9775c10e202e6d6c82393736480c0be470bf54253908d837216d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d8a01a2ef3b522523a2dfe6a83c439b5fe840f4e5a6d93c6ea19e9e395cd119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994cb131a3773f103efe26f9ea73f321e8c63412befe2dc62bc2a6e63408953e"
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
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
