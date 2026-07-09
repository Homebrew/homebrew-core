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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "528959cbafeb6606662f5c5e0483b5835aa2e5cf535532ba5dc0215561d55b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d3f6fb188deede5b333fa7da8a77ded5cb572b50c011953e8c8f1ff4827f654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "503c0f8c3023ed5206b8e36b6f6fa7f3c445b31b63da4c6362e67f0163ca96cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "38245cec152a11b420f023ff410c47a160fb4b07d5ba7ad83355063ef3a6e495"
    sha256 cellar: :any,                 arm64_linux:   "65deba92af804b86524accace1805a2c724c7a11f2937aab2a04cb68370e0544"
    sha256 cellar: :any,                 x86_64_linux:  "2ae0abf2df0a0536b6f3c5a82394bb61d5f5955dba24a0d4d1b88b1cbc50f902"
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
