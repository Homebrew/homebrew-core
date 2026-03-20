class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "51877660f39548e00267a2f6f2c07acecba4513b6f90f711f874da19cf22f8a9"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab78f25371837b0d455471f75001bbe630698e76475dab9cc11e29d0e8efbcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53e15aeff2acf8b697e3c42414d1e6c1248841c3aeeb88c15ecd2d15f49d0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4913db8659fbf16dc4ffa86c25db00fdd57dcfe778d10e562bfa3d424f4a9c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ea2a02d09379a899810a8354a91ecbf9c6cfba8a31dd498dfea9f722cbedec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e14747a05df302462555dd673e2608acc96678892063a87b0f43c5b4b1eb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d7e6c4675981ae964f31f4e41d55882410d1601aafcb7f72f37c0517fe5a56"
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
