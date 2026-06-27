class DexterLsp < Formula
  desc "Elixir LSP optimized for large codebases"
  homepage "https://github.com/remoteoss/dexter"
  url "https://github.com/remoteoss/dexter/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "94afaa0ce531ef9b47ab5f6857e91f691f558d8df0201a715826b87604595b6f"
  license "MIT"
  head "https://github.com/remoteoss/dexter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685bfac3dec78bb3ac11799a2c99bdf6bd12bb812a8a816ec3a358c69fabb699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45f69c3c798bf991b64d7106401b754dfbeeba8f16b950ca7be2efdcd400184f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf74a4ce2474ce61ab717f266e225a918293e3e6e0ac749736144e9aa5f70ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3bd00dd576bfefb6ff8755e63987d6622006bf79dd07f1865b8d2aedc54f43c"
    sha256 cellar: :any,                 arm64_linux:   "267d799f1360158b066053ffde354fd0b46f25a685e94a0843f0d4b3b258dca4"
    sha256 cellar: :any,                 x86_64_linux:  "dc80bdf389b29eab0c260773aab11f9254ef39f55cdf7b66df4873b3759df9a0"
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
