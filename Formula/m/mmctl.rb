class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.8.3.tar.gz"
  sha256 "6460842e861a4b96d786845bf51b49ae72804346a10b5f5dbf8d5c288c3fceaa"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "717d319c7b1af8fe4559f57864454167f4048cae5a04215567bc2489f6764611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717d319c7b1af8fe4559f57864454167f4048cae5a04215567bc2489f6764611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "717d319c7b1af8fe4559f57864454167f4048cae5a04215567bc2489f6764611"
    sha256 cellar: :any_skip_relocation, sonoma:        "af46b09502c6f2b37ec1e4d6a0d6dcc6e2b9b767ee33da161e95fc1234ce4fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d52de592868d0261e2e81c2616f9aefd21281b7427ff7fcdff00c61f32e1f326"
    sha256 cellar: :any,                 x86_64_linux:  "2e9e8ce4f064865cca0bbb8b6360e30f5feee49e31dcf3415a79b947ad67fb29"
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
