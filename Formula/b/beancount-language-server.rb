class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "b5f3d156dfbd1508e3e2825fbe87247969bec24a554bab3a5eec81beddca117b"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30035cc02c46d9f3999e846d3c016016355394a117306e82f4f80aea3715a34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16bc477a15d7bb325769cfce450d6b8186bff33b229add22cec64cd632b0fd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14747d6b559a6e6e47750e88aca99cf9ffdea98120a9795c09dff827e2b534ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "a58edc5d901c13058f230f1025925cc701086288a7c8e8a8f0fa6d95658bb786"
    sha256 cellar: :any_skip_relocation, ventura:       "b37ffe472aed413a8d8521d1afab3abc17e1d1673b33858f3ab7a7c55735a413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c0df24d9789b88930d8a99f916354894ac5d6a2c062d2923e866c0199419de"
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

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
