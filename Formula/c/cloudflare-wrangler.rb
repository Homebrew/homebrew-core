class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.160.0.tgz"
  sha256 "380377ff348ae45b1ee13b26db6a79c3f91a667ac38b10820ffc54a1fd996554"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00cf71a54ce926f7559b6d17e95f6b7d88934a07542de35fbb62979ca2cfe611"
    sha256 cellar: :any, arm64_tahoe:       "00cf71a54ce926f7559b6d17e95f6b7d88934a07542de35fbb62979ca2cfe611"
    sha256 cellar: :any, arm64_sequoia:     "00cf71a54ce926f7559b6d17e95f6b7d88934a07542de35fbb62979ca2cfe611"
    sha256 cellar: :any, arm64_linux:       "211df52b198d65ca06c80910352ab4af4e4780710164d571c800979fd6baf950"
    sha256 cellar: :any, x86_64_linux:      "73c5049e69e5edd36337c3963f3abd1c9f60bbd77b01edb847d4eacea4d2c1a4"
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
