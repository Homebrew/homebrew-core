class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.135.2.tar.gz"
  sha256 "45fee18513556e587c2fde187108b57879e8577c3b11f1ee753e849b463f9fe8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b74bd001f167812330134682c5bb298cfee4b8304e3b675d3d7c6d54d107f9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b74bd001f167812330134682c5bb298cfee4b8304e3b675d3d7c6d54d107f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b74bd001f167812330134682c5bb298cfee4b8304e3b675d3d7c6d54d107f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14fb2c081c0580fdf2c4f608557ed1156fcb62b31cd4596749ee71436437d64a"
    sha256 cellar: :any,                 x86_64_linux:      "d03457a5985f706c4a2b27ad9d4a7e1d68244995aef89c0ed219445c94cd7bbe"
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
