class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.41.tar.gz"
  sha256 "346eef8fd95bbad0dd85a20c4b461e5ed8918d245b8c4260326d8de2365c4242"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32dcb9668501bb43d388c39fea5873b75b00fa0868a0f4edafe9c29ec108822b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0665d301cb1e85b61758c175169d1df7c68f519b8e26c1aeee73503f6fd3fb07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74078e614b7595d63100aca5d7084cd8b99b856a4d015b1b23bc71a480ed5135"
    sha256 cellar: :any_skip_relocation, sonoma:        "30627571b19cfff33a79c95627192885a7a6342015d45c4759f78163fd8aad6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680c4631cc5ef325d3157397080ed4df836288749bfd2836a62a2adcb6f58e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39be809c1f8cdc0724c325e468fc77395ee67af0ffd8c42f6651d1f923d17c10"
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
