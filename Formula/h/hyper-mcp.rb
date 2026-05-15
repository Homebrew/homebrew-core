class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "26c7dffcd4d4bb87e7d97dc2c2ff7cf967abc38b126b1f42027ce415405114da"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aef40c79afba3d2e0403d2f7e65c6ff425964e53290b8b6ef2ed216b839150a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3023d38d58aaceedacd716d0b2d127d657850dfed1dc986907ba0c2459c59cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5ad90f9c5fe4697b9bf2878e3f2d52cd9c1e70e12902d6bf168d3199ced5e04"
    sha256 cellar: :any_skip_relocation, sonoma:        "974923f20ab5f259fc8c3bce1f12c012957ae2a9e3cfe884fede01a3b2e5d780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cdf316985724d0fe57a3919d3cf65a75b7876e1493517ab68bf96b42340d358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4903786240bd66bc34441523982293a1bd2bf08b7ae802bdac2ee0c08112fd"
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
