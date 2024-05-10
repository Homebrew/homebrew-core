require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.55.0.tgz"
  sha256 "5a89e9312eafecaaf612bbaef59875fa03f4222d440a4924a42d059879176fb5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a7514e353232c77a48b68e153428dcad2b2c7ba61f14830d06c1b07a93c6714"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40872c0712c7260b47841e64430a815b39d9c2e69f3d2f6c44e62af7e723278c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62a285fab339ee8e9c8285d8a7e5aa3851d4ddf98b9d7ea45cd029c41d47d590"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bb1ca595b692f5bb23a9e7b44f791fc0c6bd72869d0b4705b16beb17d988534"
    sha256 cellar: :any_skip_relocation, ventura:        "9de220d6e0488af9c0034b732c9b58a7a1aeb4a6efd3a7b2fb6153ef0cb8c9f9"
    sha256 cellar: :any_skip_relocation, monterey:       "2ca4603e847bba92dab900e1d134289c325326e02b66fe97a7e7949694f46bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1049a0432b10d2f07375a95a52277655469b6a4de0e56022c4c24c52fcefdad7"
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
