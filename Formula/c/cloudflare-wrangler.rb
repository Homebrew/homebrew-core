class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.24.3.tgz"
  sha256 "b21a72e861ab61f696692cd1f1cb116f2b69b2791c115093229ab86ff4e2b58b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d592640227fd90d01d19fc8eff591aee17396bef3bfe0b06e5877be6e0c7d72"
    sha256 cellar: :any,                 arm64_sonoma:  "9d592640227fd90d01d19fc8eff591aee17396bef3bfe0b06e5877be6e0c7d72"
    sha256 cellar: :any,                 arm64_ventura: "9d592640227fd90d01d19fc8eff591aee17396bef3bfe0b06e5877be6e0c7d72"
    sha256                               sonoma:        "cf7a5cb49e56bf4db027d7e26f78955f7b5c5fdd838b4f7b626a86717ea18e05"
    sha256                               ventura:       "cf7a5cb49e56bf4db027d7e26f78955f7b5c5fdd838b4f7b626a86717ea18e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb10d26461b1f22af7f82d82a027044428ba41826cc271bd80877554e02c068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20e7ce64f7e71be6d48aa6d50dbf4104a072dccb48f7c474094b6344c14c63a9"
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
