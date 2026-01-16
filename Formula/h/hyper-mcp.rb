class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "2ad6bd60736cd75f21c52a4abc9af57b65ceb152a4646a5f1c129c74970a0077"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df1ea246b507f336453cc52bc9c6e19de608accaa61fb1f73c314e7163be1cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6118f62a30e4e0998a9e6ddeaf921b545017bb3bf3ce1425955fefff3397d55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5f35406f2c841d0322dcb43502cadc931cb0fdc7f1d80b064860be22581981"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba92fb4968c98c45332b0716b0853e7078ecbcf27f0f0652137b309b15132101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00da51c3006a680a889e32f92f1416f0a71f3a026ae350154a5c754b56c83179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c9c92391627fc9a669097004d7aefb11003a0554aab8bd9729a775267156231"
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
