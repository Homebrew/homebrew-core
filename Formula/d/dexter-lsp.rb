class DexterLsp < Formula
  desc "Elixir LSP optimized for large codebases"
  homepage "https://github.com/remoteoss/dexter"
  url "https://github.com/remoteoss/dexter/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "53344b29a92ce686383c7409bc3bc7e2c639af760cd4682d14956988b574d357"
  license "MIT"
  head "https://github.com/remoteoss/dexter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67f530c0925970dbb1bc08a97a9cd83a715d0aa95933b261a270ee673220e31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40ebea0096ee7544ab1c62668699551f38e03073cece73e66decc0de13592caf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e0ec6b9a2eec4f55a4fee72e06ef5e33d370eb9c4472a089f89255b7f9ca383"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd99a681e1a889ca400b803b9924c2bfb67f76464acae3ed49370c06384a97f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa383983373b0b2d36524b659e99b1d545460800ee0ae45b5186d035e904649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab15d678edbf45bfffb3425675aa3829af5a4ef7b8f19fd019ca3d0da5f6ccb"
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
