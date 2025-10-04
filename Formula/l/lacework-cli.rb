class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.0",
      revision: "80179a87c3b316e9a6296dd35f0ba9a55e78878d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e521083572c784e2bce97b260da5d0a93407219ea4583cc793fd55d5d6e18253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e521083572c784e2bce97b260da5d0a93407219ea4583cc793fd55d5d6e18253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e521083572c784e2bce97b260da5d0a93407219ea4583cc793fd55d5d6e18253"
    sha256 cellar: :any_skip_relocation, sonoma:        "09124c001f141794c670bf7ae9ee5580a1716996ae89f48a5e322468ab76aac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a3ccc515cca95dac00477d9c1b33e0892392849568afb3dc78f841e1a04ff9"
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
