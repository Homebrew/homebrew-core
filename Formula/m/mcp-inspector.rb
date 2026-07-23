class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-1.0.0.tgz"
  sha256 "02684b5238eba62bf64cdd5cf3e9feb5d04a2feabf557c423a8298eb76ba66ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd8d28f1e65b08b7c87924ad0759422c044dcf61b8c441d9d4f708521133d2b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd8d28f1e65b08b7c87924ad0759422c044dcf61b8c441d9d4f708521133d2b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd8d28f1e65b08b7c87924ad0759422c044dcf61b8c441d9d4f708521133d2b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "526b5ce7a7ceaa8b3f9650d5114e7799b960e2e66e7221bae63496651470a2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2ff0c8327eceea3b585f4a6b9de998269aa59bf3fe11c8d946e9316b2870ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c3e3c852b14f56b8c67da2fe0665baab72245329cd1d8a73b95a798905a28c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    # Remove incompatible and unneeded prebuilt binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    rm_r(node_modules.glob("@rollup/rollup-*"))
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
