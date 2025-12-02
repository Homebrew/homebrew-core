class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.3",
      revision: "cc6f4ad38fe7339e21bf318fde9118470f2619b0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bf71c0c01a5740743d5b13b081a8d044ec59bdcf7bacfae65f7cac0c4d99db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bf71c0c01a5740743d5b13b081a8d044ec59bdcf7bacfae65f7cac0c4d99db0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf71c0c01a5740743d5b13b081a8d044ec59bdcf7bacfae65f7cac0c4d99db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f88b6adaa57557ef564979a8bf9ce7fd27131a43f1e1b3075b417c8e97e9c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e064b490d83c4c4fb0a6b8c2b177d546dfd901e859198ca3016f66ef7c17b5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a34f84c800c3b642e5e5ac6745bf3288dc7a9b326c33408fc2a1971db6c50645"
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
