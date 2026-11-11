class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.160.0.tgz"
  sha256 "380377ff348ae45b1ee13b26db6a79c3f91a667ac38b10820ffc54a1fd996554"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74611e67ff7739a537f53f64760ab47dc42fbdd01c537ce0dec34f8b4b24aff0"
    sha256 cellar: :any, arm64_tahoe:       "74611e67ff7739a537f53f64760ab47dc42fbdd01c537ce0dec34f8b4b24aff0"
    sha256 cellar: :any, arm64_sequoia:     "74611e67ff7739a537f53f64760ab47dc42fbdd01c537ce0dec34f8b4b24aff0"
    sha256 cellar: :any, arm64_linux:       "a4ef0b949573d8219be16c381004c1d53c811ffbd681b4a4259768926e0caf48"
    sha256 cellar: :any, x86_64_linux:      "f3760d971ce7ba8e51915aeb7d845e8ffa95e3fef952a2c40163913b35a6602f"
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
