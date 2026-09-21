class DexterLsp < Formula
  desc "Elixir LSP optimized for large codebases"
  homepage "https://github.com/remoteoss/dexter"
  url "https://github.com/remoteoss/dexter/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "675ad9d59678db0f7c63bd5f0672f19d7e499a26359e8af6cd1ee5272b583b8f"
  license "MIT"
  head "https://github.com/remoteoss/dexter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c66e4e613f241aa3265f2ae0a56a665b1a0b5904f54920cf335c68e1b25ce210"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3a3e835cf020d0c3d194bddc69e9e5382f23eb6f9645f62db31347dcfa3f5a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93657f0be80d0916e917f4254f9acfbe25b04fef9e84fba1b2214b9072fbff07"
    sha256 cellar: :any,                 arm64_linux:       "3775ffeeccd33f8c466c71c31ec0f7febb98315b7cc46de63e831f309b54a384"
    sha256 cellar: :any,                 x86_64_linux:      "8f66893c5ff5475af586954910c0082f4ce93e7989f895911825182a49681e57"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite" => :build

  conflicts_with "dexter", because: "both install `dexter` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", "-buildvcs=false", *std_go_args(output: bin/"dexter"), "./cmd"

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
