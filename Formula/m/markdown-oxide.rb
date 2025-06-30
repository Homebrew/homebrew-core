class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "2599ca7bda83526b2d1551e1579877fceecb43336f9c9cc1ec25d05f9020a650"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "715f5614ec10c1ce1dac7c73f66a15bbe2739150ab2f207b3da83aa476f76a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e16bab623da3d5c973504e86952343a401d05879a5346c111ce80d3f2a02d05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a76f4a4ab6f1caa891f40390183e63ebc3362c17b8c413c04f41f0be34976441"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d66fbac927b9c720be9c8cfcca53d22dc5a87d770d2ba711fd6e137fc26a674"
    sha256 cellar: :any_skip_relocation, ventura:       "ae30cf5b91d871303ca4a2b3f1174128ab430b48500d97224044cc38c7761331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20c6c08225b82c5abdeae9f6359a8d75032a35a2d7b9201a56eedbf5f629fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292ab7e605afb6c007be6c084bc357571c85d9db563c8328653c7603fa09edaf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
    assert_match(/^Content-Length: \d+/i,
      pipe_output(bin/"markdown-oxide", "Content-Length: #{json.size}\r\n\r\n#{json}"))
  end
end
