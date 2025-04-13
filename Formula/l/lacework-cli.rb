class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.1.6",
      revision: "edb312eb2ddcb7eda7e51e722c3ce1c63fdd6f30"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5803fae6de2842ffaeeb788e785b99679ad0cf2d592ae5619a43f2858c8d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5803fae6de2842ffaeeb788e785b99679ad0cf2d592ae5619a43f2858c8d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d5803fae6de2842ffaeeb788e785b99679ad0cf2d592ae5619a43f2858c8d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8f3f4cfa1d775c115a16da409f0c496c55883a3d6e80213ddf3ffe12239f12"
    sha256 cellar: :any_skip_relocation, ventura:       "db8f3f4cfa1d775c115a16da409f0c496c55883a3d6e80213ddf3ffe12239f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf2c73321f2b10b3835198a5ec532c97ed4a3bef1b562a21c3f585624c72701"
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
