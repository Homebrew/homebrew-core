require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.10.0.tgz"
  sha256 "fffdbafbb22e0c6e10351a143ac2741d8eab39e95ce02f5e92131061f07b7df0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d91021e5f94dfea6f2fd721f9a2d72bd8defbd1134d38ca454d063921570d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d91021e5f94dfea6f2fd721f9a2d72bd8defbd1134d38ca454d063921570d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d91021e5f94dfea6f2fd721f9a2d72bd8defbd1134d38ca454d063921570d8"
    sha256 cellar: :any_skip_relocation, ventura:        "65bafd4080ddedd8ba81ae8af06b92bb1a384ad8717f2778df4a0d858d11b3dc"
    sha256 cellar: :any_skip_relocation, monterey:       "65bafd4080ddedd8ba81ae8af06b92bb1a384ad8717f2778df4a0d858d11b3dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "65bafd4080ddedd8ba81ae8af06b92bb1a384ad8717f2778df4a0d858d11b3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d210743eb007a922ffbabde52f12b81762f3cc827991f976c7b14d7ab56cf0e"
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
