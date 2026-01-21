class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "984115bdf6ab8ba155cd72011a75971366dfe240811e4fdba44a957a87cae217"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3e0aa7db8c8d3eed88110e8ea14fe6983d23e5fc974ac7e5789fb934bd49b24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e0aa7db8c8d3eed88110e8ea14fe6983d23e5fc974ac7e5789fb934bd49b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e0aa7db8c8d3eed88110e8ea14fe6983d23e5fc974ac7e5789fb934bd49b24"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7e5783097b2c4891e0c13884d8f630fe7fce29ade66e54fb323739a598ff889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ccc6306eed19ec0d44e926865e961c458a71fbb708db4890e8f88e4775bee07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1423dedce5c5e18b3a3026431686c74e4f3c114f1344b48da305af1222600d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

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

    Open3.popen3(bin/"jq-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
