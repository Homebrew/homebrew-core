class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.81.0.tgz"
  sha256 "6fec94715f8817e77be3c302b8289ca409270accab718988b636f27f5c278796"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541d3999e60aaa8ed5245298ddfcec90e17c3f2781321d81ccc7736191f194cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "541d3999e60aaa8ed5245298ddfcec90e17c3f2781321d81ccc7736191f194cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "541d3999e60aaa8ed5245298ddfcec90e17c3f2781321d81ccc7736191f194cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "29d891e8fd711586b9cc8b9e026c5060482212d654147198321b7932e7159bba"
    sha256 cellar: :any_skip_relocation, ventura:       "29d891e8fd711586b9cc8b9e026c5060482212d654147198321b7932e7159bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19b5237a8b19b3a0102ccfbdb6c67a9f2ff7c01a6db017fb34b81d7e818cdcf3"
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
