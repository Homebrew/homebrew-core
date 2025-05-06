class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.14.2.tgz"
  sha256 "2b89beac1edf2f9d92f819b00b9fa59b33d03f7a91aa98b9e7a286ad996028b7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "690817a724fd21490950ec12cbcf5da4d017b750e9f3303b7c56b63684241f43"
    sha256 cellar: :any,                 arm64_sonoma:  "690817a724fd21490950ec12cbcf5da4d017b750e9f3303b7c56b63684241f43"
    sha256 cellar: :any,                 arm64_ventura: "690817a724fd21490950ec12cbcf5da4d017b750e9f3303b7c56b63684241f43"
    sha256                               sonoma:        "05569bc80ae87e53243bf9ac9caf9fc235f154a466a7a19f3eff3f4c2959721d"
    sha256                               ventura:       "05569bc80ae87e53243bf9ac9caf9fc235f154a466a7a19f3eff3f4c2959721d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3112f2e38f674a04f2c449e09b675f00bce0baaf42b76cd2233b026d7799352b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19f2b9acd0e2a78e5f09996f9e1dcc6d04ef4f1f9ed5d15ac8c1019be366cdea"
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
