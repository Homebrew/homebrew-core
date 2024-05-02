class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.50.0",
      revision: "a4ad8552648d4aa4a6e8cffae3eb008f73ffeacf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b20a343726b8ae42e92aab05635d223fefa71198844bc2a36189e75075a204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "174e6183e541e4eb69cdb2d154acebc9c957650d94f579bca5b0fbbec0e51b90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86930ced10d5a413e4ae7bf6d7e53f09c5242e8e24fb4417e139a04b6b88eac1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f54db248825900e45c202354aa14172d18709501240a51211f65b51940f4384"
    sha256 cellar: :any_skip_relocation, ventura:        "24a586d585ac76948736b40aff7a893b143c4fa0cbb493d6f0a545ae6a5e8664"
    sha256 cellar: :any_skip_relocation, monterey:       "ec83680b4f382209ae57b7010afafa0265d647ec6e98ec7985187a79db234d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d6670e42a1b6773d92886a7f1820e2a2011563e72f4fabc28401c9e6f1d1ce"
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
