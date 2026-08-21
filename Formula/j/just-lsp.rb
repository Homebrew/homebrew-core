class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.6.2.tar.gz"
  sha256 "1ee32a4e4143ffcf7dd8a58f3a01162de146023a54d43346936a60980cbe7d4a"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff803cabc4a6aa887fef98006ebcf8cf89fb1efec6e61056a5753aeba4bacf51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4bf50dd11e4bfeb5572b2633244a113ef8d9a2261a13499b1b59e19cc57c30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e94bbc0985d08e966afd3e08a76b5a27fd97fccfab6ab30abf4cb533e60fcd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71bd3ea550b0a8a6ec9963d0aaacf5ab91d80776efad86e3e143290faed2d99"
    sha256 cellar: :any,                 arm64_linux:   "24a315ab04018570d873f3dfe049e847d33b32e414281a50af5011771c881e55"
    sha256 cellar: :any,                 x86_64_linux:  "a666e9b1b8f095b8d2b313a43483b75ad20dd7078b1499fd4be5bc13db74e449"
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
