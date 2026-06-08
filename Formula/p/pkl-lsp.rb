class PklLsp < Formula
  desc "Language server for Pkl"
  homepage "https://pkl-lang.org/lsp/current/index.html"
  url "https://github.com/apple/pkl-lsp/releases/download/0.7.0/pkl-lsp-0.7.0.jar"
  sha256 "1cab4e2a8f15ab6e59e84dbbfa7da29bad5088246c3e220aaac8e0bdfcd2addc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebc148644911cd7188e0ff1fa73a18c2552cf41a92b7badd296cbf0114c2a4cf"
  end

  depends_on "openjdk"

  def install
    libexec.install "pkl-lsp-#{version}.jar" => "pkl-lsp.jar"
    bin.write_jar_script libexec/"pkl-lsp.jar", "pkl-lsp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pkl-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"pkl-lsp") do |stdin, stdout, _, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      stdin.close
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      Process.kill("TERM", w.pid)
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
