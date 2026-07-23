class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.9.0.tar.gz"
  sha256 "86a16933aa996c8ec2f19d672a743cb2c0be153617833873ede0f90c0e7399f4"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d9e68ab65e2c0d90edbfd84c3d375304189e62ff323759e0dab254f3dc5a55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d9e68ab65e2c0d90edbfd84c3d375304189e62ff323759e0dab254f3dc5a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d9e68ab65e2c0d90edbfd84c3d375304189e62ff323759e0dab254f3dc5a55"
    sha256 cellar: :any_skip_relocation, sonoma:        "f31d1ee2044557a7f90d90ba9b4dfe5ba8e1bc20fe0c25ceab277c49763adc6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513c46d21bf41f283bcfe9836f1d9cfb6b75e18b48099a24848a1712e4b9ea1d"
    sha256 cellar: :any,                 x86_64_linux:  "e0da3932380b1e740b90289074beebcae0ff028fedcda697afd3981ce941081e"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
