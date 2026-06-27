class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.105.0.tgz"
  sha256 "ff7c2074e200fc50efbdea49eb31bf1b51e2596ee858e5e2c96623ee34f0304f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f6bcfbe76ce6193d4183e03b01550cc300fba0f2b63d7f991d98bae544a518b"
    sha256 cellar: :any, arm64_sequoia: "832bf4547acfff6382f092cfb6eb0b82142078805ba4c3ef0d44c59eacd0e81a"
    sha256 cellar: :any, arm64_sonoma:  "832bf4547acfff6382f092cfb6eb0b82142078805ba4c3ef0d44c59eacd0e81a"
    sha256 cellar: :any, sonoma:        "49eb45c3ee740b32e44ca239a9aba11ec514b7b3404b9ff2d1d40888c727af70"
    sha256 cellar: :any, arm64_linux:   "faa22c5a15dcb3b9759312c2872296fd6393257fede42210356f4c3f4b87c5a1"
    sha256 cellar: :any, x86_64_linux:  "6ef2d57640aff93d681369bb8633872f53560af386160b89df8efe5ec3a17bf9"
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
