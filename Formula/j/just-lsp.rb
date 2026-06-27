class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.4.7.tar.gz"
  sha256 "ec32c00edc76d3c0c1721fe1b227c9b86b586f9d5d19bfb8e1c5159104f6f6b2"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddebbe09aa816ada35fa0c93c46b9806807be6dcf4e3c17fcd62e9276f75c2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22b1fd60f7acfe3532055eb2e3f38d464040f8542c9dca042a24e052592e0e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7114b478c62624c0d97c148be8f34d435a5fe20d69e0575500e7d88b1cec7d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "07eda15b8a52e5594734f3e43affbd25fab489ed521b32d52f6225617c07220d"
    sha256 cellar: :any,                 arm64_linux:   "eba45d9cdf8292232635f5fc4ba21cf35879f95ac0a74e8c44703cab21438932"
    sha256 cellar: :any,                 x86_64_linux:  "e52c21598deef3e26e38053297ef2568229f0052612393d5fd6e53ec80739da3"
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
