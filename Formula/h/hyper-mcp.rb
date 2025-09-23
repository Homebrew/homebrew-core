class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "ba62a075311462426b56b6524fb59f7298e9d9a7a74bc74e89671352e7cd35ae"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ebfef44acefa02049bf5e852cf4e3f16be92b3e7a2cf8dd99763da1d1e16c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a40f57cf3556706e5b717dada11611bdb7afa58dc9dc4551af71f27c7c32697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ffe1bfa3373de6953edb64233ffe1520e6db93ed494fc9b34c99d9123eb585e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3552476365a056ed3eb7a784a16fbfee4cad0353f4a761d00b8b9e935d4318db"
    sha256 cellar: :any_skip_relocation, sonoma:        "426172b8c3bde66218cd7e8defb6670e2b361e692299572df5c653ff06ba5865"
    sha256 cellar: :any_skip_relocation, ventura:       "6cfd0f9ea2a7e77bc3df9493deb86cf099fa753c3233902a5e78ccfc8f15d002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "296026bbfb6e03d01494ac4e371cef72edaee90a40159d5b957503f3c71c58e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446046d5d6b7849f8f2df82546c081ba891df18228a3db1519817e501da50e40"
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
