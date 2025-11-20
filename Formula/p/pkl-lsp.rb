class PklLsp < Formula
  desc "Language server for Pkl"
  homepage "https://pkl-lang.org/lsp/current/index.html"
  url "https://github.com/apple/pkl-lsp/releases/download/0.5.1/pkl-lsp-0.5.1.jar"
  sha256 "a08fff7061a57b882562344119f2d95ae0e8cc4a9e410df61d5678a0cd8d293f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc0492cdb49cfab7487dcebb28b69713f4287a4c38763e66be5c7f6076797331"
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
