class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.19.0",
      revision: "0b8664cca2190d2bf08b24c35ccd6ed4cabade12"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f108105d5879d7afaba48857a6ad3eeccd85fd1157f3f13cbfd14f626d01f595"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "092279d271fec8585d1837afda61119cd925eada0bb104c86cbc44d0cda97784"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebddbfabdf1bb62883f01c25bdb149bc096fc924146823add2c2462fb2f949cb"
    sha256 cellar: :any_skip_relocation, ventura:        "51240e8020cf4161d6d8a4868fe4ffbb42ca8b5bc6d2a913f547e666ba94f25d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8ff821b98a844fb4b30bf2487b539b7e6f7b3ce74f64e1414573a1111adbe26"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6a0008d520ca7d640efaf2ed02b70fd5dcdb1227deb693390602244d0f3f2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa36bad2191d91279b7e72e332a7a28f0089a592ebeb6fb162c7e6d02685d3ec"
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
