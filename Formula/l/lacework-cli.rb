class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.1.9",
      revision: "13647e25ab2257125186b205cb3670153b8b3bf2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd372e44b3b42379d9ca968edcf7212ead0860e384ab19147cb68a0fca7cd5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd372e44b3b42379d9ca968edcf7212ead0860e384ab19147cb68a0fca7cd5dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd372e44b3b42379d9ca968edcf7212ead0860e384ab19147cb68a0fca7cd5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "053d97656fc41a38b57dc23ceae35891d766ccbc3d28ee7f0a7bcd4191f685a2"
    sha256 cellar: :any_skip_relocation, ventura:       "053d97656fc41a38b57dc23ceae35891d766ccbc3d28ee7f0a7bcd4191f685a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5a11966cfdf1afde9a92106d639aac3b1c4ccdc522ae903e7591c690f11ac0"
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
