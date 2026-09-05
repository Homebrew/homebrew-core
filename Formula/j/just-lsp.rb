class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.7.1.tar.gz"
  sha256 "c8d88cdeca4e585020a2e9e3ec6620d794b7f71887cff1ba15ae420496eec6fc"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd671925cf305b9d470fa87dcc6d6f06c93fed64b0d77743defa4f98f2b227f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e8829c8b98691d700b08e7e4ac6c4cbccdd9f86ee2a600f5aef3c376d26ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34cf5bdc21cdae5d6d15cc360e4b0ad4bf84496a07f2f916b4b6c9753659bd0b"
    sha256 cellar: :any,                 arm64_linux:   "c7b544ca797ad693a3cb8c19b03e0fdf182648a4dcca42f19be325cf233902a1"
    sha256 cellar: :any,                 x86_64_linux:  "b61b5fe5c584f6b6acf35c6d7dfe28eca2b2c498bec22af1f459c026dce3b024"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
