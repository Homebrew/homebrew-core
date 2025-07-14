class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "badf5c72063ae3232bd18f938980308f77fe2b4c5f3b8db6fccb8ca6db523834"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9cec3d399e0d6c5d50e89d4dcf8f953b77fd362b592f6e63b0b0be286e9ed42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cec3d399e0d6c5d50e89d4dcf8f953b77fd362b592f6e63b0b0be286e9ed42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9cec3d399e0d6c5d50e89d4dcf8f953b77fd362b592f6e63b0b0be286e9ed42"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc89cf44dcdd6924883a47fca57336d075678c5c7862d4849c7ebe9aa23fc04"
    sha256 cellar: :any_skip_relocation, ventura:       "ecc89cf44dcdd6924883a47fca57336d075678c5c7862d4849c7ebe9aa23fc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5464b2c3c72bc4753a5be84bff2e6bd42bf466bef660afaf28bbe3f26de5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0feaf2b9afcdabee223722922c26b851e2eb3536f5a873b6529f5a3c073b2ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

    expected = JSON.parse(<<~JSON)
      {
        "message": null,
        "name": null
      }
    JSON
    query = ".[0] | {message: .test.message, name: .test.name}"

    assert_equal expected, JSON.parse(shell_output("#{bin}/jq-lsp --query '#{query}'"))
  end
end
