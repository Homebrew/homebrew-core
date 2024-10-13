class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "fa95baf5919cce866088724b00744975854c56823a3037b91de27b72521519b3"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9281b323db65a69a4702eb1acbe127d2ec1bda30c96136ce9fcf87fe44077810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baf8e9583f7d1861133d62ff19a74204419fb8136ad005f7575cc0946b2131b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a579559df9351434cb4c99aa46b614e7c9104c101b0867e1030a61ae81c8cd99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75a1f40c9e1761b7f0826d7dd77e63c9536b76ecca613976fc3446b7f141d7d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "626978642fb69d2b9725f02d7004d987b3cc5337817385c0e05d89aa2734c1de"
    sha256 cellar: :any_skip_relocation, ventura:        "092673817643d6bf8d30b07c52276e936ce0b88388ff3bd96d9ef943573ac47f"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ce9b42955dbccb9e83294246c6de9d7d9843e1541856e78d48ec9b16713285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a5a275ca270b7c652d5127c0e5709a3203f9ca954d49b0c02c82c2e86dbbe3"
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
