class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "571b7c6b8b95d98a679cf2413cf4328b0538f6eebcd34a8825f771b59788c664"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79cbc40932d0f72b0d1bba86bbb548995315131dc4355b5cfd0c53647534a2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97168de0a0bfd8c72502878308dfd9caf9330e106dbf83f3bd7f1b10c6d58d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a88363f26c9afa6b62281bd2b5ed293ab65c2ff18f30a4221c6c84e07e7cd05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6d70fe5a1dca7bb9ad6f3190f7539521cec46bcf9803cfd74ec9a7ca6f9dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eac0f3d0164a4a8a9dd1ced72b11f369eaac60e10e5a08f1bfa48837fd85ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b287b82c8634c4568beef0ba47b76d46316630d6e8b366cc699b4bdaec4589cc"
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
