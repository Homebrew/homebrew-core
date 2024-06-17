class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "d56f8d2d30f471b5f5011ffff9b55da9fecaec13f34a5f8f2ec0d6aa28cd3ded"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82445c3d7c22f602ef3d39f8a7a54efc668e3e969f1dc8e693f84deb4cec453a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3c1c6656edce2de56daa8a4c11521ed2fff5750986f6fd6bd6e94820a9677b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae88ec185948138db98a150726cba59c3ace351a0e7a94c523a0f2d698d59a85"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b328672412a7458c70d3b3c5a5034b2255ae4ef013379b47d4c2eec6c5535f"
    sha256 cellar: :any_skip_relocation, ventura:        "89f8dc470bd27ce82c2e1af1732108ac7ad3652080c88c0df2b691bb52200629"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c278470076f15fb10e4bbeea29145d4965a47ed155012be2bfef8a34e978e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b67edb1060d6dc6bba0e449a2f43bfbf7aa9d3fb4e195fc637f6ea81941153fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
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

    Open3.popen3("#{bin}/beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
