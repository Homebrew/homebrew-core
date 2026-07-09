class MarkdownOxide < Formula
  desc "Personal Knowledge Management System for the LSP"
  homepage "https://oxide.md"
  url "https://github.com/Feel-ix-343/markdown-oxide/archive/refs/tags/v0.25.12.tar.gz"
  sha256 "fc7c472c2bd93a9b8f58848d71f054ed02442310f5328081f3036a7ce79040cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26eee8911b28b3b8df7101eeb5118f12955b5b2ad1e14260e977f4482008cb25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a9aa4008a7d922da5e393b40e54b8a7d5ea095774146d75b8b9fafa29652743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d25cd6ca3a605c3487f5eb52218489b616c973d261a2b53981eae632a3489c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfc4714bddfc452bd56377fd9b815b6da589d5368c7420fa9f26886d29d2fb49"
    sha256 cellar: :any,                 arm64_linux:   "c3ff98f1cf490ea2d039c52fe402e6360890e3112694d8b11f1fd0fb4340372d"
    sha256 cellar: :any,                 x86_64_linux:  "bb20c018508074fd3cb7ac662415ac0d4c1ccf037499994e65aeb5c216ee2bfa"
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
