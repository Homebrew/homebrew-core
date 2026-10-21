class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.19.5",
      revision: "873aaa3a8b6de9ec365b25288345383cdf954f18"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e34486ff607d1dd1ce8271a31fcc16de43bc52d26244f52c1832f70bb9d7a833"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e34486ff607d1dd1ce8271a31fcc16de43bc52d26244f52c1832f70bb9d7a833"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e34486ff607d1dd1ce8271a31fcc16de43bc52d26244f52c1832f70bb9d7a833"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62110cc4a5756531300b6b928f75fc456f254a96177597a1e89e1adb8d6cdc54"
    sha256 cellar: :any,                 x86_64_linux:      "bee0342c316b6aa00dceeaad72536b0e870215220dfc75afbed65b3b720b6fa5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
