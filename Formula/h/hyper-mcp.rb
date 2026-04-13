class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "73869915279433766b8657c1393d6db4c615794cbbed8d45fe298f9568f87f19"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c760691c928ac4e5964d6af9da5798acf253cbae7005db7ddd341b160b7a24b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "486c665b208b68c3e50f5273fe0c054a6fef24fb44dfd2dd58fb3e39d0dbf8af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693ad7a290c6fd141aa2b5bf8f8fd50f67ce1570ceb076bf0899a0d472f64e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "32d286363cfa3cac50c3d3e6186db40d979e85aee7c155e2d3d4545c54748fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62074386be303acfb6a92ff0555d88afe273ffea1d09142d36e857bbac6da541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55554e2bcb7e8709b7d2038be76ef69cf953b4df4068703b157a98e61b195ddd"
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
