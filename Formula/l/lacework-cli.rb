class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.14.1",
      revision: "8091de30979a5f6c6dd5485c483597219d9d4200"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5664da7c7c2ce565c71545855786f109dfbbc24175b070a10607723d8153ff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5664da7c7c2ce565c71545855786f109dfbbc24175b070a10607723d8153ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5664da7c7c2ce565c71545855786f109dfbbc24175b070a10607723d8153ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "17c47a68a6144566c13095f5b6ea032c6baf44644a91cc326dd7fc3dc61df654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc4bc4ffa35815897db645f66a1c4b999d7fa116487920fdaafb0434924cd0b8"
    sha256 cellar: :any,                 x86_64_linux:  "72bf66b57eb09c39eb51ca06e55b392c8d2c2fc751ec77643ff2a2b4754ce473"
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
