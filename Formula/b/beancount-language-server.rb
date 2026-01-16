class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.7.0.tar.gz"
  sha256 "fc1badabc64cb534cdb644c2b9a220fa8ae4261fff47d7f5a173bda1923a39e9"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ac6433de4107ee46bd43c3457a3b24b921a76e551693dccefc4a4515757c6dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b7409a2473ba1b9341260e37f02ba4a051ef23286ed102fc5ec1babd09b7a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e724bfa4a8bb12dcae0ef358e9d1bd2bafc74e6df4665cb0b929a6d6e142ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "88697d03a4b59ddbd0b81cad601f073788418bc8a476fa6b3bd95c7ae9fed16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f386a1fa6c9514c459b85d22a8b70f7840f6a730ce78fb24083750a99df2456c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9c5c26c1934111ed5ec809f455d5887b3e832c5b7ed78c901564a54fda67ec"
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

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end
