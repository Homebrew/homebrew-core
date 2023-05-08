class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.18.3",
      revision: "e2775cf390accb6e38a0b1acfcf61859e23997f0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d3ca30c92496e8891f9e38f011146f396d603d7696d6d32404199301cbd667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c78761b2e9784c1cac47ff28e4b5c688174af426d5d1e51e82a262fd2241e7cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fafa1de5401ae53d286748afff60c43ed8cea063959ff93e568ffc29a1861ed"
    sha256 cellar: :any_skip_relocation, ventura:        "17c303dbadba3f8fa272e0005e15182cccce2f29db9c1827f9dd4bf0c9ba310b"
    sha256 cellar: :any_skip_relocation, monterey:       "46da7a48969d9471aed8cd1a11fc6a1b47019a26a13d1e609de135e029980e94"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc100c9236d4c44b99997f5e95e5bd429364153c190beff79d8b4976cf39eb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1c44313143cb74b8fee8b77f197a51fb0a4628a75146d3cbdca015b7a091a72"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
