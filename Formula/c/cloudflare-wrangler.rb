class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.90.1.tgz"
  sha256 "5acb12753f54593f2b41223dab65edce062d89b10b2193ff1bdfb6fd6b813076"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd04a11d41e2f2f2617300fc3b2198ce6af7241260e2d77b3beb8ec9d8e4410f"
    sha256 cellar: :any,                 arm64_sequoia: "725a0c4037b715c04f4d51ea83c39bf6c76e7ebb299f742daa9085cd1aab6fe0"
    sha256 cellar: :any,                 arm64_sonoma:  "725a0c4037b715c04f4d51ea83c39bf6c76e7ebb299f742daa9085cd1aab6fe0"
    sha256 cellar: :any,                 sonoma:        "768930fe7e7f55c624d2c44ab034b8070910106f084de9adcc65f3d226913862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c4a442e3c66dfc9891ea06b6b4e8f8cf88f4cd52fc3fbbbf332b909a53dbdbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7170c2b8ef787e79702213701cb4a72d284e2770fa10a7101ff7ee302db7344f"
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
