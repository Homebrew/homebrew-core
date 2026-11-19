class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.136.0.tar.gz"
  sha256 "5610f89c64d90a97f75a8f63b3b90c74c68d75fbf2bdc651747c4f507c588eab"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d94f3937ecf076d4bd2c4227578f495a56d6c4146c6afba14077b7ad87f68446"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d94f3937ecf076d4bd2c4227578f495a56d6c4146c6afba14077b7ad87f68446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d94f3937ecf076d4bd2c4227578f495a56d6c4146c6afba14077b7ad87f68446"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "530fe40cfb363fcbcbf9717397171d3cae384784c4a3ba84ddd7d577f2c4966d"
    sha256 cellar: :any,                 x86_64_linux:      "a1c25fcc1239696249a3807c71a3d037d7b62919ec9a6396b775cbc81cecafd1"
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
