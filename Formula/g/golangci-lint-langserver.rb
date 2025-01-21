class GolangciLintLangserver < Formula
  desc "Language server for `golangci-lint`"
  homepage "https://github.com/nametake/golangci-lint-langserver"
  url "https://github.com/nametake/golangci-lint-langserver/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "65c2ffa9b71da3fe7298d4b86ae5cd64108bdc8313026d9613f19956d5855abc"
  license "MIT"
  head "https://github.com/nametake/golangci-lint-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ab1753c327357e8f7325e2bd468924bf834143b1fdd2cf828f80035ad2014e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ab1753c327357e8f7325e2bd468924bf834143b1fdd2cf828f80035ad2014e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03ab1753c327357e8f7325e2bd468924bf834143b1fdd2cf828f80035ad2014e"
    sha256 cellar: :any_skip_relocation, sonoma:        "17469ab438354ef58d3a530707a5a5738cfbd89536113047c7daf4b57ac8e1dd"
    sha256 cellar: :any_skip_relocation, ventura:       "17469ab438354ef58d3a530707a5a5738cfbd89536113047c7daf4b57ac8e1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd547ec2ba0a55aa871810f06c0089f87eca216131a9ec3e00a23efedb9fdb77"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"golangci-lint-langserver", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
