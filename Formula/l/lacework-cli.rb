class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.15.1",
      revision: "554a118f95baeaba249ae95d005735fdef951b5f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30dfd7cd39ba37e6c916dc32cd0dac4d23342432eedd8650f809df638f8dbae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30dfd7cd39ba37e6c916dc32cd0dac4d23342432eedd8650f809df638f8dbae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30dfd7cd39ba37e6c916dc32cd0dac4d23342432eedd8650f809df638f8dbae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e43626d62801356b1632b941a2ca717804cf621070dea953fdddeb9eab6a9b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49738fe99314be98f14473b2bd4bb1dfb0da1a9baec1d43624df2601d3b34d9d"
    sha256 cellar: :any,                 x86_64_linux:  "5c69f3a027081faa986079557afb18929c3e7b56181de7ff0f216508dc4e505f"
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

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
