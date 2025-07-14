class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/tuananh/hyper-mcp"
  url "https://github.com/tuananh/hyper-mcp/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "36a850d7292293d9169ee50f4ef915bbe37c77aa8bc0048d06b8e4b8c6553113"
  license "Apache-2.0"
  head "https://github.com/tuananh/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8917afdf6798d7f43df3bb5a82db3448a15cf4762edac774ca324b1285012a5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694dfc8b4ee94dd5c92ec7956700478a06f3d572a9d6dcd10ab3e3f04dd96cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "579bf9f8d3b7813742a8a169995b622d7e46394eab64b1cf2e54ba227b2d70ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea9a7c990d504a89bd7a4b4e77d5ad94198917bdc83777c8f93175f2d12b0ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "5c995391cf5888bf339024096020ab35f996e8380fa83fc9a0ace4cc740dd892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "babe57801d67a562cdd26af5f5718461c18d75b4e78385e35725456161cda075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18447ca13ff3fe7b626eac68443adc078de631542603520403878d79b95e90ee"
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
