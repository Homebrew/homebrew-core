class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/1.9.2.tar.gz"
  sha256 "f2673b169e4d9fbb1cba4f47d8d90452023fb19921fda5565375ec9020317498"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3706c546f4094adf3e5bdf53fabdcd425bd623835e8b4cafe1802bf220abdcc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "837a0c5b62df48ce8d1469c4dae7607423cf16566171ded5932ca9b0a3c392bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8213539154346f591d39e4e1594b75013f898c227b4e92e4dff6c67412a9db4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "786b3c6ef59350110b0c7fc8ba0785787fd9b33004611a3b723f515e9a9c04e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9235ff896d1955d442758b350b19dbe03496ac7aed9af26f214d6cacc25c345e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f34b4c9f7b7e4ceaf9cb3c4d9c891b8f3f751af79e88db163d2538ff3846e0e"
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
