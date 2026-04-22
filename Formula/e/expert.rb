class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/elixir-lang/expert/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "209eebddf264407f43848f2d9584210e1869b0103885c1cfab89ce48a2421c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9f4b95e9ca15c8c2b53c7ee9c346d53c24df1509d1be124868c350b9042c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef5f201bbb3d9d686c40522a172bd791dceeca164e4c61902b7f56b32ca3d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e4d0bdb1935d6edf3ee3ced12625277bef20a197582681b2a4c582899cd9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7f9ce56676e96018dc3c0bba839567b514432078891ad8712efc4b1faf316f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c80d566b7bf95b48166a9a1737414f6a9d27a2cb067614344e753338a138de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9158f8ecf797e2b959ef28491256effb3d447ee23b852a8d57075ac6be194e0b"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "xz" => :build
  depends_on "zig@0.15" => :build

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"

    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"
    system "just", "burrito-local"

    bin.install "apps/expert/burrito_out/expert_#{os}_#{arch}" => "expert"
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
