class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.51.0.tgz"
  sha256 "9f4edd8b82e3ca32d8a0cc739017febdf1a6f7de20b23a397600ee6232362096"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ed8ac3575df109d28a249de1a8f2111bc86b6d14e732185056a7593d9167f8f"
    sha256 cellar: :any,                 arm64_sequoia: "335e7b29371119eaa141247f92502a0cd0ee21cfbd2a5be64f333aaa531f9a60"
    sha256 cellar: :any,                 arm64_sonoma:  "335e7b29371119eaa141247f92502a0cd0ee21cfbd2a5be64f333aaa531f9a60"
    sha256 cellar: :any,                 sonoma:        "b4857c80e00bb5cc038daaadeaf9a8b1f5d855d640010bcd60f2bf602a048f7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90088472507c32e6e2aa7b65f273f0a5c94b8ef85f29d52e685addbb913762f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c3f4d718e5c66a38ee208a0bf18903819216e6bbc65b04f7766fd5f5c5f3d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
