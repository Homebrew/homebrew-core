require "language/node"

class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler2"
  url "https://registry.npmjs.org/wrangler/-/wrangler-2.9.0.tgz"
  sha256 "651eab30ec0cb38034efcd8dbf0c8576ea7b537c024510accaff2bcadecc74fd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "231e2d7dd0b70bc9220d70aac8491e7b04ff8085960fd01322516da788228ceb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "231e2d7dd0b70bc9220d70aac8491e7b04ff8085960fd01322516da788228ceb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "231e2d7dd0b70bc9220d70aac8491e7b04ff8085960fd01322516da788228ceb"
    sha256 cellar: :any_skip_relocation, ventura:        "50496f18786ac5c3c8f34d742523888011c89a7dc22d147beba1b6775de5b3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "50496f18786ac5c3c8f34d742523888011c89a7dc22d147beba1b6775de5b3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "50496f18786ac5c3c8f34d742523888011c89a7dc22d147beba1b6775de5b3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed596e83c4fae539b2a660c3ad701c485863c834c4a83b2c7816dfc4d1c25d3"
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
