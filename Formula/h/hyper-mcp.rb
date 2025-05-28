class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "32a7515748856f2564006dec54b3ad822dee90187ce88c384c18f4e5cacc0066"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a47ba9534141b16a9f7599a0ae988a98c6d12c21d57655be20330833a1b9324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f718a26b90661c85b10b330128bc2176c5eddbc2e7f762057f212b8c34c330"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1cae9171ecf44e4af0685fb6b33300bf4be6aa66392903e83672d84578a7315"
    sha256 cellar: :any_skip_relocation, sonoma:        "54ab3644c4c208c07084484366629734e2eea3fc969bbe840b92213571a0675c"
    sha256 cellar: :any_skip_relocation, ventura:       "10086f91485d4a86d7688d8b77a8c2145a2ac67fb799c3d45d4d365852989268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e35f8ba102fa85f79279a21802ce8b0484fbc1119c59420b20f2f48aef88920b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6bece954e8e2edbe6cd19a2a8817dc3776c1d3db12157f7d1dce12998daace8"
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
        "plugins": []
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
