class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.13.2.tgz"
  sha256 "d5e07b235bcb035514c784fb916156fd60d4abeee6447d28b6798884304c7772"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29e8f1afec2c71a3580d3ad26f392150f0eca1944e438cd9ae446c1e746b82f7"
    sha256 cellar: :any,                 arm64_sonoma:  "29e8f1afec2c71a3580d3ad26f392150f0eca1944e438cd9ae446c1e746b82f7"
    sha256 cellar: :any,                 arm64_ventura: "29e8f1afec2c71a3580d3ad26f392150f0eca1944e438cd9ae446c1e746b82f7"
    sha256                               sonoma:        "0f17bd70c2baaaa6cfa2a773af24dd5857bbbb452b21335ec0cb2236757d38f8"
    sha256                               ventura:       "0f17bd70c2baaaa6cfa2a773af24dd5857bbbb452b21335ec0cb2236757d38f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc09cb509a3295d9f3ea898f392357e8992de54a843dd4ea20833ad03c89a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f141fc6e449eee701daf3b73a35f703587848faa17a51067c355cdd50248437"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
