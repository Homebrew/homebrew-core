class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.109.1.tgz"
  sha256 "ad6b8f18ffd763141dd6f847b8f9941f607d8af7168dc32923f7b98d319a2ddb"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9565a03ad71b6d0ab8bebda07a484b80464177914c88507cfadc8a1d1e4993ec"
    sha256 cellar: :any,                 arm64_sonoma:  "9565a03ad71b6d0ab8bebda07a484b80464177914c88507cfadc8a1d1e4993ec"
    sha256 cellar: :any,                 arm64_ventura: "9565a03ad71b6d0ab8bebda07a484b80464177914c88507cfadc8a1d1e4993ec"
    sha256                               sonoma:        "b52600c83b574817e6914635b8fb8907075588c9a44876273fea527f74f87022"
    sha256                               ventura:       "b52600c83b574817e6914635b8fb8907075588c9a44876273fea527f74f87022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb96fffea93d3e477ecb2143dd3d841ef2721b7ab8a59e5502209037ad54bc6"
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
