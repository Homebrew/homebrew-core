class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.80.4.tgz"
  sha256 "0aaded648b727f65518882f83501d39abf57b7c2f42135ca061190dc9cf32ea9"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "752ec3b05178a3377528e86a4ca73628aa8c2d3c621233b0fb0f9c88ed31eea7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "752ec3b05178a3377528e86a4ca73628aa8c2d3c621233b0fb0f9c88ed31eea7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "752ec3b05178a3377528e86a4ca73628aa8c2d3c621233b0fb0f9c88ed31eea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6623b33cec089dab7292b67fd10238d4d3d9d5367083d028af23c92930fd633f"
    sha256 cellar: :any_skip_relocation, ventura:       "6623b33cec089dab7292b67fd10238d4d3d9d5367083d028af23c92930fd633f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81249304e32670821c2e39a2fff5b9c8e8c8a11da63facb285e89221d18553d3"
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
