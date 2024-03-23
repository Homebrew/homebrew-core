class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.49.0",
      revision: "19ac99d21158013eec542c919047fd2000b01ed2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "232ff450d6f2ecde55e3c1d98250be88afcde6ff92970060b3623510ce8c2cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55608840a476f4f3db82d5aafd98ae190d433eacee4b7dbbc7a411b9192a6ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c964d532e7785830c4752722c6347145be3cf9d0e2fa173936bd1f3e4d5a0714"
    sha256 cellar: :any_skip_relocation, sonoma:         "db66d54ff51920de36756223a9d795995014f17e37b168a446923eaa8679e31a"
    sha256 cellar: :any_skip_relocation, ventura:        "52777bd7659fc1c76e4c689893971f4de078755237393db05e654ef4c2b6b9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "21fb4db2437600542960b5637fea3460b0a749337e26e8bcfe54c92d69eabb56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72547b642d8025ea08cd23840894d446a71fb2067faa9f721d9e0238d16d4e3"
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
