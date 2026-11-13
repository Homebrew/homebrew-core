class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.161.0.tgz"
  sha256 "60e778b3469468bb17cad4add9ef41245b6f13942fa3b94a420ff9c49a00cb7a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "232a7dbdb454a3229e3d5076083e30c90bec8be7e17b6bc21fd24ad4cb323a8f"
    sha256 cellar: :any, arm64_tahoe:       "232a7dbdb454a3229e3d5076083e30c90bec8be7e17b6bc21fd24ad4cb323a8f"
    sha256 cellar: :any, arm64_sequoia:     "232a7dbdb454a3229e3d5076083e30c90bec8be7e17b6bc21fd24ad4cb323a8f"
    sha256 cellar: :any, arm64_linux:       "0c82d0cd62a2ae6e5793b278b5402b83d0f285dc9f184d0355c88e3e363a9ea5"
    sha256 cellar: :any, x86_64_linux:      "22bde94c11295fa30b427fa04f68a8b911db3db67d9d92499397b6e94525a9c0"
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
