class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "2599ca7bda83526b2d1551e1579877fceecb43336f9c9cc1ec25d05f9020a650"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98350db8d6676af90380a98b3e311e5e47cbfbfa72cf4ed56263057712aaaeb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba5c072a88bd570bc04b33915ad0a32fb78c9c4ecf8361e4679e3c0f012d9d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66fa6fb21b2fa55f55aa0ab8ad4cdac2afba0cc8accfbe80a1457a49acaf8663"
    sha256 cellar: :any_skip_relocation, sonoma:        "a369384e0093fcdc92d589574d0be89ce67e4916880d6e1f12a32566b900cae2"
    sha256 cellar: :any_skip_relocation, ventura:       "be5f57b647811a80a6a214372bceac9deb42e489f077a94d946b76a14cca1427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60adfbecf246120b975b769f5fc65c4e0b8cb57a36cb35b3c12d8d9b84e2d501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90df6853192f47353ec807c6285a237302ac9caea504029dba8a7fc7ca8e84e4"
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
