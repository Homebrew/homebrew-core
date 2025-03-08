class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.178.0.tar.gz"
  sha256 "b52f2b2d718c7512a999fff536f495b04c7acad3d423c326baf1b5b48cde4ef1"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad087b84c5b9efa1ad04ee7de53e2879b732ed39e6e22f040338a70486eb3c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dad087b84c5b9efa1ad04ee7de53e2879b732ed39e6e22f040338a70486eb3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dad087b84c5b9efa1ad04ee7de53e2879b732ed39e6e22f040338a70486eb3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7bed055727491bab02918a0fd85c82f0f5609a71905fe96850699f3b2e65c4"
    sha256 cellar: :any_skip_relocation, ventura:       "648224cd9336773997ee6c56236995c2df0f9c577ad027f6c98ab36696f76105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b531ccecc6c0850a318ae12b61965f86cef15391033622e35e08c1e3ae1d10a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
