class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "5e2717e3b552f11f8025dd9609e835ede64d0396a3d20ce27ea32e08cef9d580"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d508ea46a7808cb0564914e37d8d69064b4219cbdf7a6733c8ece013c1aa94a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011eccb05cf271829c3074ff43a886e545c07192dd7240450c5d1ee24cdc0e29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a180bf1f66b9c57c365c7e90b5bc5c620b95008800ef91bb79276f812026dfbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "57287ebae5f7a502e1d0e72ccc5400fc794845be604242105664c6211618c51a"
    sha256 cellar: :any,                 arm64_linux:   "5d2e46157ba78b04eaec0c19d4b6efea3c54c5e7014ddc5eb45e759e88288450"
    sha256 cellar: :any,                 x86_64_linux:  "a21f4e98fb6a7a9e18807cd80cdf0d2630d3a49b42bc6aa08a2efd3f84e0900d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "plugins": {}
      }
    JSON

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "protocolVersion": "2024-11-05",
          "capabilities": {
            "roots": {},
            "sampling": {},
            "experimental": {}
          },
          "clientInfo": {
            "name": "hyper-mcp",
            "version": "#{version}"
          }
        }
      }
    JSON

    require "open3"
    Open3.popen3(bin/"hyper-mcp", "--config-file", testpath/"config.json") do |stdin, stdout, _, w|
      sleep 2
      stdin.puts JSON.generate(JSON.parse(init_json))
      Timeout.timeout(10) do
        stdout.each do |line|
          break if line.include? "\"version\":\"#{version}\""
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
