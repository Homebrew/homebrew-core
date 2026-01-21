class CodebookLsp < Formula
  desc "Code-aware spell checker language server"
  homepage "https://github.com/blopker/codebook"
  url "https://github.com/blopker/codebook/archive/refs/tags/v0.3.29.tar.gz"
  sha256 "0e6c3a78a527be108cf507e315122a2008d5897ee048940bfab71dc4f7b11c51"
  license "MIT"
  head "https://github.com/blopker/codebook.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0fd2175b0c5d74df0ceb2deb4ac8d24f634a5536b67cd2baae78a122d0ec3bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a1c4785862010d91a420716abc2eb6f7c52c43803fe183fc896fb48d58ebac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad1f640eaeb5a1fbc89c2823498d805b37af859ec22462ed94040974c8d9f729"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe6b3eacc4cb6ed7a82e6396c5b3f2db8755b63b36363cbee48f8136691e53f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db663c5d16868cd374d540334f511c813f4e72c1910e9404acca2937216b7266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "945f10e1c1e0102b721c6f537387680b86169b9936eed1505315446fb216fb44"
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
