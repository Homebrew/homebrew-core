class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.80.1.tgz"
  sha256 "46c3047e8ed6fe94bc53f457b7ca6b8f483827f413c5d24f1a5ba05af14fb0dd"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b85c4b127feeb59342319f99960c0b024c5e3ab8d594754cb8e6d21459d5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b85c4b127feeb59342319f99960c0b024c5e3ab8d594754cb8e6d21459d5d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30b85c4b127feeb59342319f99960c0b024c5e3ab8d594754cb8e6d21459d5d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6931255888c0b80602229410a57e62d988e40753ba7bacd40d89436fec1a445"
    sha256 cellar: :any_skip_relocation, ventura:       "b6931255888c0b80602229410a57e62d988e40753ba7bacd40d89436fec1a445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9f6a003aec7d051558f294271120535863b4987a5dab81c714e20c7e5e3f70"
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
