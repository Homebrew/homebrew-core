class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.4.8.tar.gz"
  sha256 "dd62ebb8da4e1c3e55c915a3ad28b04f8962528c7f0dcc31a1ae0873620ce207"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2b9dc154af3535cf7671460f06860976b334648015e531e5b90e6c26dfb54a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a66cc74305583a01d18f534f6fd5630b1a4d7305555f468fa0e7a2aedfe96b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83da24b820f08c14eae0c9b07769efcb78dbc27f096c52140a162479ca162f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4080122497f38d2fb79c325444fbecb781aa1149aa471fbe7878ace0413d13"
    sha256 cellar: :any,                 arm64_linux:   "9bcdb201f27b58e067c292bc6bec27a9ebb19711580a8794e1381d35e0026ecc"
    sha256 cellar: :any,                 x86_64_linux:  "1ba975c213dfe7ab1b42d52847cce947aa5f502949b681ee0ac19eb8305b3c08"
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
