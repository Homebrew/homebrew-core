class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.10.0",
      revision: "9d92a8de6c7906c19b6bba48fc8203095e5943bc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "638af4c6da8b2531c0dfc87408298fa224b1049d0f0995c8e24018ad51d1fba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "638af4c6da8b2531c0dfc87408298fa224b1049d0f0995c8e24018ad51d1fba1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638af4c6da8b2531c0dfc87408298fa224b1049d0f0995c8e24018ad51d1fba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4075e5791e4c938ce23592ed6631ea9eb02b573d1d2a2961d9010ff7784f40f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52f465e2ccfa430a8480307b9112ea6369b6525813498665f562d2a4fa2b9b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d23930fb2378e73300f504bab1f344a79b4cb954b69813be6a38390e789ba6"
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
