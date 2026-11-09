class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.134.0.tar.gz"
  sha256 "3d0788a0837f65a83f80db95fc1a66e45be573554eb84144f9fadb82bfed3aa7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67ca2af458f63615b6b4e34cb0af6cbe09c90237a407c50245c6d27fbff5c49d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67ca2af458f63615b6b4e34cb0af6cbe09c90237a407c50245c6d27fbff5c49d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67ca2af458f63615b6b4e34cb0af6cbe09c90237a407c50245c6d27fbff5c49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "984702f0a3d39f6442e2f8e76fe1226992705eda815a7d365d20e80b2f682812"
    sha256 cellar: :any,                 x86_64_linux:      "ea5c1243f994a10f85cfac3b16bfe2137ee85b82b93694d2cba80c673d909dd4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
