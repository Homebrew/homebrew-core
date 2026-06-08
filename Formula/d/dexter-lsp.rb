class DexterLsp < Formula
  desc "Elixir LSP optimized for large codebases"
  homepage "https://github.com/remoteoss/dexter"
  url "https://github.com/remoteoss/dexter/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6be8063a47b1258789f0a7855dde16cdacb30888d294ad940f8e8cfc2146b0f9"
  license "MIT"
  head "https://github.com/remoteoss/dexter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63769777d60c963beb469d2d6316fa684f6e25950ff17b06548668584f17eca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6494adf1187f6ca90e37834c78d784fc3459886f7116049472a658ba2a486152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f13f4fbe6d6735229fa9c3858ebd1804a0e3cd7d50e63c2772b15ea173341d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7fbc4036c3a2a7ceedd030d8c52510f4fd34b30ae0a6d1a1e2d19510588ad60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1dc04f0da6b19b27e91237d566631f6ef5c13548af961ebdb796442517c206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aec2aa6bde3cb262efc12f061473b8f858f1c89b3d17c9aa6a32c22bdd03c89"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :build

  conflicts_with "dexter", because: "both install `dexter` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", "-buildvcs=false", *std_go_args(ldflags: "-s -w", output: bin/"dexter"), "./cmd"

    generate_completions_from_executable(bin/"dexter", "completion")
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

    Open3.popen3(bin/"dexter", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
