class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.30.tar.gz"
  sha256 "d7285193a902cbde672c72626f732ec8be6f1e5b4d927f3d15a3d37a82af8010"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62599f44082f7ce6c7a7c25dc03f56323b923f1a6644661a12120d8b9c097c7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43e67e5b820c1629d99a4be96d29a1bb3a794e645d2147d98d85e007416c00e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcceb753c9e17d5ba761c23eb30a79142df554da4fb85a4bec241377d82335c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cecc46efc92c39f6f14549611c4af8c9db8fe5543f0c49eeb60a5005c31f9907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e26f223c395329fefe8d7ff385a99e7d11995993bfd8590ab3748995b8f8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c458961fe592fd1c2037c33494f008887f2edfc459841271830061614cc7d80d"
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
