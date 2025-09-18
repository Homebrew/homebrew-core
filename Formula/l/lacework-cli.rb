class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.7.0",
      revision: "1a0ec63e70092991ce2ff30346a03442c4fae156"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a56c7fab608de0ff4ebc767e4d49fa6c067208b3340acc838b162ebd55902166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56c7fab608de0ff4ebc767e4d49fa6c067208b3340acc838b162ebd55902166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56c7fab608de0ff4ebc767e4d49fa6c067208b3340acc838b162ebd55902166"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a56c7fab608de0ff4ebc767e4d49fa6c067208b3340acc838b162ebd55902166"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2c31d2d01fd44e78d49ed6cc46a0c4eb7f3f050510f2ca974b1bd8da938aa1f"
    sha256 cellar: :any_skip_relocation, ventura:       "b2c31d2d01fd44e78d49ed6cc46a0c4eb7f3f050510f2ca974b1bd8da938aa1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dc7852f0f8cd4eb6a0d8737cebf0fb958b8c43bae117c3913c3f45052382ce6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
