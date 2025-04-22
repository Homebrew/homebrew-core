class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.189.0.tar.gz"
  sha256 "fbe64ad717eff666b5fcf494a314f540263a2c9b7a630d1f9c01e639fa03af6f"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f29d85a9af12b0c7760f61721978a6ad424fb12c19a560be8150c4eb827d3ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f29d85a9af12b0c7760f61721978a6ad424fb12c19a560be8150c4eb827d3ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f29d85a9af12b0c7760f61721978a6ad424fb12c19a560be8150c4eb827d3ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "da81744326a603ebcc1b8f77ae44d1ad780eb58d3318f6cd2cfc7cf01f726e54"
    sha256 cellar: :any_skip_relocation, ventura:       "34913480ea5841346ec0f2cfc7d41ff1bc0bbbdd3b09d8cdb41e58c3cdebe860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed4cd4d95e98b52f9084d1705d8f224ee2eef261ce22ac6c66c4c89219c4fbf"
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
