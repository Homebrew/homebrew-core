class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.17.2",
      revision: "b62efbec9b82a308507d22e2a233f491c5a0b450"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7301f6f7d88e874fedf366865af48862cd39314a9cda681208f23f9afb1399ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7301f6f7d88e874fedf366865af48862cd39314a9cda681208f23f9afb1399ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7301f6f7d88e874fedf366865af48862cd39314a9cda681208f23f9afb1399ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "339ec4534fc1ff9441816c56434638ddb2251f6e1dc5e7ac1ac6204e2d275d75"
    sha256 cellar: :any,                 x86_64_linux:      "d312c4123f60e16e1e9a28c80c0ef6da8ddb4f0374de7d31943108ac0174745d"
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
