class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.37.tar.gz"
  sha256 "8a9c25fc6dab3168a5ca9b6ead5339863977d647e87e7ff3589d4ccdbcae81dd"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b290a799d689a6a3fd7864d653e55208869f993a308edd7b560af9467f619f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9059c7dcb9c1719e40b46253bd7e94e53e95b7fda0e4ca7cafcb0a3ab0dfb6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa41bf3f576993c16a27561c38372b14f9aad0ec88f3aed9fb58b4325d648b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5411405f43fd232b39677caf1463b1be5bbb0ea755d057f22a803fcd71ad3094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad605c412c964a7651bc0550432f444b3b46ef044ab3c9dcca634dc0ca489b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b0aa5350a9e57266a4b9d82c2564c7627459b4b65a83fdfc63c005dc1b712c"
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
