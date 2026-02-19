class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "5cf8bf55a42fb4899df8963e0e5095de3c359bcb6c6686ac9b6f00c1ef378fdd"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895fcfd4f5734f8f51f2e89d8ea4be18a74249940343a1fc49a3b0e7601829ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f07d5aecf2a502ed6d1acc9214fe1525c0767b294a8b7201d4b17f2e932161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c469bb957dc214e4c7309d19173544f8cc3036081da7901eb0558d865751df21"
    sha256 cellar: :any_skip_relocation, sonoma:        "4de4e850e1433db51922082758f34a58b5813848559dc37ed6820d5dc958decc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "923ae89399b22a5d6a86379619e02a38083ffa908bec27c160ef099715025237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c305a855c6b0b1f73a0a792e0fea0148cc1f85488ff8e6a3ce5ea4decbb58f0"
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
