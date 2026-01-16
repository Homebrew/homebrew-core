class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.9.0",
      revision: "082af585a830302848957e9410bb229c103cc33c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4954c4d02278cbe88d4d93c55e0c89189c2030aa51165dd4d5e8c74568ec032a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4954c4d02278cbe88d4d93c55e0c89189c2030aa51165dd4d5e8c74568ec032a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4954c4d02278cbe88d4d93c55e0c89189c2030aa51165dd4d5e8c74568ec032a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5cf005fde74f07972ca0fb2134daa51744631af14b176172f51805e461011e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42ca5d0f6c5b6e1ce62c5ddd403a36562a46f228673783d7a3b4a22e858f85ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "902a508ef12ab2d806c84e6168ae6daee758bfc6657e7f9adea4599df5273e69"
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
