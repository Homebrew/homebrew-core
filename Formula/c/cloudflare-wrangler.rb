class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.81.0.tgz"
  sha256 "a538ccc747ffcf9c9bea6a262f7038b181f556aca4f7a31a7ee4ed4890e9f0b6"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a663a50d32bc87f5db9b9a2aa66e6273057cc5950fb3902ac8408153c567ebf3"
    sha256 cellar: :any,                 arm64_sequoia: "f8e74f886d63c834e2c6ee0357d38cecce1ece92640114357c86195fe831b9d5"
    sha256 cellar: :any,                 arm64_sonoma:  "f8e74f886d63c834e2c6ee0357d38cecce1ece92640114357c86195fe831b9d5"
    sha256 cellar: :any,                 sonoma:        "0f7a36a855718fb0f8ba0ed8285ebf293681e41e0c322d09b50bbf071d46a4cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7c757e3a6af3df038617b69ff3cebec6ae9ed9d48ec7f4619c3846c04bfbff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d173b14763a0c0a0d3e7d02f5481832c54f913f3b4541dd42ea3a1058401d83"
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
