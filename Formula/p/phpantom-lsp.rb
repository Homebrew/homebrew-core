class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/AJenbo/phpantom_lsp"
  url "https://github.com/AJenbo/phpantom_lsp/archive/refs/tags/0.8.0.tar.gz"
  sha256 "a91e6c106a4c22476a61e251023debddbc084c91065485ad1926f47c6b775138"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a3dfcbf59e11ef11f0c156be9e48f0f0ca8ac96417ddee7a35bc2aa72fbfb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5452e27af9eb12abef381120648b2e10788b00e4043bb1cf3d81b42021254192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8993d849576697186291b433497e8428589a30925fde1b6ac2469a80c1b2f61a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbd36f3d201028b6cbfc3d74441cf249630f05c3900635e1aff0027ffd982a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b993c4b8399070f0e65ff717294392aa537f028f671345c2454e1328c5321f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cad2ac759d6b9b969c7b6f173c1ff80c79da62105f6f33ebbbfe15a9a82c4d2"
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/phpantom_lsp --stdio 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
