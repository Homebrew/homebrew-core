class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.11.1.tar.gz"
  sha256 "da7d24be42cf8cd3d736be7532c71e8229f9abe208d3e52676c960fa0fa67fd6"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fa5f865b7c4dc2dfd57c5f755b87a63576c05147ef583fee4649abf52744813"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a85a5338eca2d7e7bca1ce69c279b64c77a856246ee1d57ad625fcbff504596f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cbe3122a497440873ffe583a73b8688936a3237d9228b6673ba5d6258e41698"
    sha256 cellar: :any,                 arm64_linux:       "d5c4b25b97e3f99dc9c87a181f3cac140280854c9c27516ba3534924a90753eb"
    sha256 cellar: :any,                 x86_64_linux:      "394061a911c8e16b04b1dcf1e84e7fe6774c833c625b280ea9da7219e7adc661"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
