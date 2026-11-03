class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.156.1.tgz"
  sha256 "8e45df33c890c8ff14a7165bcfb46df149cd868014da94fec0aa9d318f0ca2e5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f32ccc458dc3247a06e467533e582e874f96510333b3c0c6b56c772ef230adee"
    sha256 cellar: :any, arm64_tahoe:       "f32ccc458dc3247a06e467533e582e874f96510333b3c0c6b56c772ef230adee"
    sha256 cellar: :any, arm64_sequoia:     "f32ccc458dc3247a06e467533e582e874f96510333b3c0c6b56c772ef230adee"
    sha256 cellar: :any, arm64_linux:       "406466d31247d5365fec7740811a75b553d8d137f06d7647cafbfe5b546fc28f"
    sha256 cellar: :any, x86_64_linux:      "1b2bfeabfd2768019a67c8f5da3a18f2346dcb7dac8f5c7167cea3e6c9995c2c"
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
