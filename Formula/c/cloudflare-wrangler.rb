class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.42.0.tgz"
  sha256 "3561987d0acdfe2e3e346c61a02257dbb7b7b0a355805bb2d4fc78f34c19e47f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69e61d8655db2cf064b8f6c19fe958a24657982554e74dd091b622e772e92f7d"
    sha256 cellar: :any,                 arm64_sequoia: "2cc16aa248a154283bd72afd367a87664e8957cb9292f52bc8de9de99848d17f"
    sha256 cellar: :any,                 arm64_sonoma:  "2cc16aa248a154283bd72afd367a87664e8957cb9292f52bc8de9de99848d17f"
    sha256 cellar: :any,                 sonoma:        "3b3c000fdb8724049ce81131376e016f146a4ff26a7af370039d8bdc266bf42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626223d0930b22853eaa15feff18e709cc34cf57d10d5bb8f2a6a3fc4d009061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89baf5c30a3aa753dd55f00db72ab55b6eaa4b3f4832f19b02475bc6511954b5"
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
