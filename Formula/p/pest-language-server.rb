class PestLanguageServer < Formula
  desc "Language Server Protocol server for pest"
  homepage "https://pest.rs/"
  url "https://github.com/pest-parser/pest-ide-tools/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "5b6222266e16aced64de83b5b7e54e5c2acea13d684b4f37b17c36c956cd605e"
  license "Apache-2.0"

  depends_on "rust" => :build
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "language-server")
  end

  test do
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

    Open3.popen3("#{bin}/pest-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
