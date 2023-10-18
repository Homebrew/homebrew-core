class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.34.0",
      revision: "9e17d790377ef847c51720a794d31723b60d81ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78bf7e438def38121e82acdad98d7a9c0fbddaa449228bb10c45f652ee04b5b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ff2d1f646df1cc0c57fd9f6be2301a26c5c990eae7d7a297f3e143f551413a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6531bf219291713a3643053af0fc7b902d6ee10e04cbb79fff78059d57620d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c840df51596077129fd7a2633d97054790bef8f280a289714cf0509da208b7b"
    sha256 cellar: :any_skip_relocation, ventura:        "fd328fdc91e1c7635c84810dc66022e8835f094be74035b2c04b5d5da1b87d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "36e240f9a2adb753adb835f5ec28542e63f263dc06afde4350471a1ef7c2b73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612a6cb39b96fa7e9146013fe17a8510a0865ef1a5221ae14b145deae2a51da7"
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
