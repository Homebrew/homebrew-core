class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.114.0.tgz"
  sha256 "6a3c24556331642111a1ae96f01f46494b909608ff8fc799d0b9c0818cb9df2b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7efcdab8065e2d2faa769484c6f7738670c194ac72f95d1f98c9e0b8982517d1"
    sha256 cellar: :any, arm64_sequoia: "7efcdab8065e2d2faa769484c6f7738670c194ac72f95d1f98c9e0b8982517d1"
    sha256 cellar: :any, arm64_sonoma:  "7efcdab8065e2d2faa769484c6f7738670c194ac72f95d1f98c9e0b8982517d1"
    sha256 cellar: :any, sonoma:        "7cec68baca8c2f52510c2625c7dac0bb44e405d866e3efb4e9c2328a8a666f9d"
    sha256 cellar: :any, arm64_linux:   "c88f88ffa2fa1d95a5da7b4aa44002be4b9709a8223cc30fe0423bab6c0fedc1"
    sha256 cellar: :any, x86_64_linux:  "c15d5716ae95e226c4191b1c78bad1f33a1391c23a710534caa7b260396d4c89"
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
