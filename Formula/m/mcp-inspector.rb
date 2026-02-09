class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.20.0.tgz"
  sha256 "9288e465ba4be28523276841a5a2b2949c99acaeabe144b5e6e11ecbadc67a55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2d24f8c0c6ad6e39f748a2117fccaebb91825f2b2973304ba395dd350626bee0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      bun_vendor_dir = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules/@oven"
      bun_vendor_dir.glob("bun-linux-*-musl*").each(&:rmtree)
    end

    if OS.mac?
      rollup_vendor_dir = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules/@rollup"
      rollup_vendor_dir.glob("rollup-darwin-*").each(&:rmtree)
    end
  end

  test do
    ENV["CLIENT_PORT"] = free_port.to_s
    ENV["SERVER_PORT"] = free_port.to_s

    output_log = testpath/"output.log"
    pid = spawn bin/"mcp-inspector", [:out, :err] => output_log.to_s
    sleep 10
    assert_match "Starting MCP inspector...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
