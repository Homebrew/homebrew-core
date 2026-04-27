class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.94.2.tar.gz"
  sha256 "8ccfb8ae69601a00a2368507e7193d62ad5de276c669e78c949ffecff3b46399"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc12160f87b349e8e808c964e71c4d5fa33eb9cc4ee5e04717dbcf1dcb9a42c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a4ec1b5bb2193b21a1ea73b77552dc8af81d291a468917846ef4bcf48a2842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcc0c645f5516856620723d753aa28d0e00b2b0449fe3df55dc29db53ceb2d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "82398378c9604c7e0f3dbf743a3915edf316959fb738c309aca609ed5d0ff1d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5da443419f50403c9904076451f24f2ae7ca6f9d5f1ae8d0c60f03b63792462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0fa993fa01381da47c1490a80a241963ada4a4305c348c9ac4235072c70fc2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
