class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.50.0.tgz"
  sha256 "8882e7c3192137048d2fb368e82622c3c2d62c6fa8e5ad9e53529d1152dfa407"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "276698efb3b2032f757046bc8532f09c23bf4c83b135da97382bdc0e4b4e50ae"
    sha256 cellar: :any,                 arm64_sequoia: "694011bd54559763a82749cd4b99a2d1013838d395570f0cd5fccb46c9f61a5d"
    sha256 cellar: :any,                 arm64_sonoma:  "694011bd54559763a82749cd4b99a2d1013838d395570f0cd5fccb46c9f61a5d"
    sha256 cellar: :any,                 sonoma:        "cf4535e8ef4a387ac5f8c1e97354547033e543641f2b233b47f4ad9a51600e57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4982cb20f429dcb3f9ee630831dc390cbd417b8320d926e033b63e548d2b43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90dec54a27bce4387d676c6bd69cb77e26e79f5b3778841f953413184a0a897d"
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
