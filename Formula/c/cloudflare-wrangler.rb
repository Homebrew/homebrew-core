class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.114.0.tgz"
  sha256 "71f56cf995e95d8bd7f7fe6b31a4976085e5cbdd1dd73538d45f330e562099ec"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dd598a685608e92165d36411b50f77eb285ec33c60dbd78dc0d18446f545774"
    sha256 cellar: :any,                 arm64_sonoma:  "5dd598a685608e92165d36411b50f77eb285ec33c60dbd78dc0d18446f545774"
    sha256 cellar: :any,                 arm64_ventura: "5dd598a685608e92165d36411b50f77eb285ec33c60dbd78dc0d18446f545774"
    sha256                               sonoma:        "bb44624a634c59fb0a7f29b0e33b37aaae5fadedbbdf94f05c09aad6fc6bdc20"
    sha256                               ventura:       "bb44624a634c59fb0a7f29b0e33b37aaae5fadedbbdf94f05c09aad6fc6bdc20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c776ce462356e645786490ee0a3d984a3e63dd26c68f0886689f657e686f7d5"
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
