class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.15.2",
      revision: "301df8688dcd5eac2b471ba141c400fa36d00aeb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c169f3671b78bd2d86f7378cf76ed1493c1b765874301aabef0a156fbf660e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c169f3671b78bd2d86f7378cf76ed1493c1b765874301aabef0a156fbf660e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c169f3671b78bd2d86f7378cf76ed1493c1b765874301aabef0a156fbf660e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a49a2bdca71af4747d8a6e04d17ef4506cef438ade125ba594792b856ea522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db7457c36ac31f71ff18ecf87de75483396108c8220c9b1661de05bebb5215e"
    sha256 cellar: :any,                 x86_64_linux:  "fcbe4d0457fd2c48cb8d1546bed590ba5fae1f5edc8cffff8ef9d3d9c621ea65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
