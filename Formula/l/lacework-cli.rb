class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.1.8",
      revision: "5dc4efe5773504eb894653ab20bc2b26cab97c86"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329dfd780775f835ea7c0f134831592189ec9c2e7174fc80707dc3151119a389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329dfd780775f835ea7c0f134831592189ec9c2e7174fc80707dc3151119a389"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "329dfd780775f835ea7c0f134831592189ec9c2e7174fc80707dc3151119a389"
    sha256 cellar: :any_skip_relocation, sonoma:        "34535df8f1c7a189982f3ea6cd80db550edb9d6c49406b53a9febf3f5be350e4"
    sha256 cellar: :any_skip_relocation, ventura:       "34535df8f1c7a189982f3ea6cd80db550edb9d6c49406b53a9febf3f5be350e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6460728b1d201800d44a150dc4f17566d577c329b7c2ea8cbac83138ccc262"
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
