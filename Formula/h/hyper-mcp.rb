class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "fe4fbd44e26d81c2537aa6c82a619d0b88636bb32907fa3ff7c96e2493f5de06"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09b7ad4ff52e8e7f54e81c467976c2d926db93ea5f37fb77551a6e10f2322114"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ab6b007bdb1b691d9edf3312cb828b2325014583ecb1560a374bf6f5ebfd43a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "980278ec3c0f8be2510d30449a1998e68585291416ec0c763454751ccf350ff4"
    sha256 cellar: :any,                 arm64_linux:       "955da75a07472ad82dccf4892e33766bc038531b227656f6c9f6097a320a34ae"
    sha256 cellar: :any,                 x86_64_linux:      "4bf54ad5f40180f7ff9d3ceb3793d7f80b015b5b66840e608e6b9d292e1e785b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
