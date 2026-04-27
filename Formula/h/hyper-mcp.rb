class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "908293c86e54db4641e3925caad7e6b4345084a60f3472ad16da8b10a5764ab3"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ccc64c4e61009bec69f524ce27574de467d88ce4bb0fbe5935eda36e58789f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29e5e913cbf7c324f263a2b7364fcba405da1106428818acb936311941dab975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1420b89e218a763b425d2ca7c0475a0723aee18d9cb86bfcaf605ccad6ce0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b8372b4d13e05ac927f98d19a6e6e267e6f0773e5d7486bcbd44e8880274058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "300a4e6a8aa1869fb9654b2ec72c2915b27fb7a003b0ba61994382b063a7fd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f65dc0977ec734df1dc08d92bb0a719bdd4f11990671ff5748b9223bee8911d"
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
