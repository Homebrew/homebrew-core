class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "345b0a7478c6160583c25b8600da8eae9c2e05e125db0e0b08371d7bb6310650"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edb2a332dbdd191d955c0f1ebe60b9e8e53b3cfb114cef24fe91b33e276b3aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed7af3c403560c8fa91d08362dda0ba0a1a3bd83d12819a603e7486bad18bea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "944d1fe4791b61607e87ca53be0d142cdcf84fedf3d82e4ad8eb7e52405aaecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc49d6cb777fef3ed30c92b5bcef4c50bf422b82c771776c40351e46e4dc215f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd3e7f91b47867c6fa635e02afee29ab88f89dd13d66009f491586e06c94ac41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892088ee044863d6851397c71a134a161e989cc7a7d1081afa9fcd794666d6af"
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
