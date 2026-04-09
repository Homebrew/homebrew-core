class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.36.tar.gz"
  sha256 "1b929e41d543e25622d4c610699ad24da60f12ee4c729a57f01c546318b90082"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f97856ac93b423dd7ce46c3da06b934caf972b07099bebd0566c034a5b960917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e8acb2a09b17421dc0c635ccaa2792ee6db1a36c24bade7d8436bf5aef3763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab6ac546da32063e49f19cba219739322b984d95c21b420864d6ae0fcdba4b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b34de21f3cb08b0e5cd2bacff41be78b90df96116f695bdb917fdb5d2919e2e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d6bcccdf3ea51a95f220e1c337fa98d3d8438e53409285fe0ed2a6b4c65e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6d228ce76c20340ee8f43ddb90e2392e0dd4224c0d46a6554a4920c872de25"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/codebook-lsp")
  end

  test do
    assert_match "codebook-lsp #{version}", shell_output("#{bin}/codebook-lsp --version")
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

    Open3.popen3(bin/"codebook-lsp", "serve") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
