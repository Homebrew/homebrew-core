require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.53.0.tgz"
  sha256 "7de0445546775e3d9b7e8f0714324091ec069b715dfaf8503f9a3b0392423d93"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e9ba5efdf74ca18a68caa007e28a6a3cd68ab227252cee653c1fd3512b66af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e9ba5efdf74ca18a68caa007e28a6a3cd68ab227252cee653c1fd3512b66af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4e9ba5efdf74ca18a68caa007e28a6a3cd68ab227252cee653c1fd3512b66af"
    sha256 cellar: :any_skip_relocation, sonoma:         "a81270e1a970ab6088c9469ff462566c6b2ffd7ef46add824f005b0ac67f37f2"
    sha256 cellar: :any_skip_relocation, ventura:        "a81270e1a970ab6088c9469ff462566c6b2ffd7ef46add824f005b0ac67f37f2"
    sha256 cellar: :any_skip_relocation, monterey:       "a81270e1a970ab6088c9469ff462566c6b2ffd7ef46add824f005b0ac67f37f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b298e033ae1e3944805b805fe9b43019a7a50afb492a0e79e7622708d8d000"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
