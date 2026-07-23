class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.113.0.tgz"
  sha256 "5c82ed6792501c8ba831d0dddc53bdab2afdbaab1f8a7b3842d46ba3fd190ddf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9927673955bdfac6fd440e1af541d6d1e99e4a5934ca68892906a7616460737"
    sha256 cellar: :any, arm64_sequoia: "f9927673955bdfac6fd440e1af541d6d1e99e4a5934ca68892906a7616460737"
    sha256 cellar: :any, arm64_sonoma:  "f9927673955bdfac6fd440e1af541d6d1e99e4a5934ca68892906a7616460737"
    sha256 cellar: :any, sonoma:        "dffb3b201d5a75f52b9b0cdd3fde880000a4491b6fbe91a6b07880b368b76d91"
    sha256 cellar: :any, arm64_linux:   "c242923f53c299710ba3cdc373a4e4ed4cbdef7485426e21d14e4cef4e3713e8"
    sha256 cellar: :any, x86_64_linux:  "2531b904a4b961f3c587b48d8aefeefabc8774e0784e64c17e05a3e25af3f4ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
