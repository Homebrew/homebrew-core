class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.53.0",
      revision: "a49e85f504b3b01e261fa84fdfcb327c706a5320"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caddf2b30b7504f6ace713cb18045e5092fc10946c9e9305e7a0fd37a324d496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caddf2b30b7504f6ace713cb18045e5092fc10946c9e9305e7a0fd37a324d496"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caddf2b30b7504f6ace713cb18045e5092fc10946c9e9305e7a0fd37a324d496"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e7e62156c8f2cbfac474bfb04b4f2619d013531eb329aca0894d7658d8ac6a7"
    sha256 cellar: :any_skip_relocation, ventura:       "2e7e62156c8f2cbfac474bfb04b4f2619d013531eb329aca0894d7658d8ac6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed8739fb996cc7dc82ee7815d6cc401f470b67429e3be941292370cfaf42f52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
