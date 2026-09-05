class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.129.0.tgz"
  sha256 "08912bc89315a123bd22c8c29813bde70838e0b0e7eaee4369b8e0ba02dac81c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3864b7834349b4d49b4afc8ba54cc2e9dbe88790b3c7f9e5249f91029e1021fa"
    sha256 cellar: :any, arm64_sequoia: "3864b7834349b4d49b4afc8ba54cc2e9dbe88790b3c7f9e5249f91029e1021fa"
    sha256 cellar: :any, arm64_sonoma:  "3864b7834349b4d49b4afc8ba54cc2e9dbe88790b3c7f9e5249f91029e1021fa"
    sha256 cellar: :any, arm64_linux:   "f267ae2409321ba54aaa7ea868e9cbb79cab0b7af24244114917497c2a77aa41"
    sha256 cellar: :any, x86_64_linux:  "405d5626bf5d64817cdd382c12e28acdcb6b6415ec7daf0f592bfa10ba89b633"
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
