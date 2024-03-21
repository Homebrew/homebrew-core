class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.48.0",
      revision: "f7c21edd9f4a7469ed14277fb55da269f83ac4cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bcaa49851f8ac7d8475cdea9ffd489f53893076db9ed26f63440cd8dc28c8b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d04c3499b429be2759868ab4b7429bc39593ff9716942bca8f1eb5f804c6b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4ffa4625dc255b1d1a194bf2b250f928b88b0a3b77d08823f596490bd1328d"
    sha256 cellar: :any_skip_relocation, sonoma:         "851612957f05236323662dfb1fb82bea52fcbda0eb9d592fe8cbfec0a94e644e"
    sha256 cellar: :any_skip_relocation, ventura:        "b70743df29174895837ef7238b9f03492e3a47f429d2a2488b97d14e6983a86b"
    sha256 cellar: :any_skip_relocation, monterey:       "059ac251d1bb652f9a2f010d83ac2c45026a5cb9178929adbea65722306b11f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7db13251a6b05f30a23f49eff202c5908ad56c31bb75a21158f0e128f44be07"
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
