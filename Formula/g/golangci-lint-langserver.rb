class GolangciLintLangserver < Formula
  desc "Language server for `golangci-lint`"
  homepage "https://github.com/nametake/golangci-lint-langserver"
  url "https://github.com/nametake/golangci-lint-langserver/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "bdda9b1138f0a6cbfec0b2a93ef64111410bf16a82583c659e1b57f11ed93936"
  license "MIT"
  head "https://github.com/nametake/golangci-lint-langserver.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b9cd130cddc6d9dd601a0ed223ae6868ea4c9095247ea1f860b728a41d813d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b9cd130cddc6d9dd601a0ed223ae6868ea4c9095247ea1f860b728a41d813d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b9cd130cddc6d9dd601a0ed223ae6868ea4c9095247ea1f860b728a41d813d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa20c1efcdd23c9e6c3a0d1ad8439374309d8c5826ddb59f59ed952205254afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10bf1b26ff7728cebb5f35c6950e8ba4fa697222e416ec05c0bfffbae2ecd535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc965eebeebd065ca1a21f765a294705fadf2f5ea77d22f883e03d81ec78be97"
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
