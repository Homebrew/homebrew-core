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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b7532a96b5aec1237712481d2c972422a33ecad68b563b21c41e46884424fe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "233321b8fc1ec55832bede4a75d653cfef4d8a81b87510b851436240fe33f2f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e323d74b1933776901dd6945cba3b6d3303b565ade7e0540ada3775f99c700"
    sha256 cellar: :any_skip_relocation, sonoma:         "883a592c1d34fb02102bb3bc52ca4163cf86c2e3c29fb374d4e1634090e05011"
    sha256 cellar: :any_skip_relocation, ventura:        "b5618eb2316b5b627380290a5c3ace17e48abcbc53067256bb09ee81a6e59478"
    sha256 cellar: :any_skip_relocation, monterey:       "913920a1aa1394d2754cae55ca77f9938c077057dc7f7c773610bc562d0474f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff3188886c382a37e0cabbc2b0a1fa654b903d21d801c01156f9b42c8c85545"
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
