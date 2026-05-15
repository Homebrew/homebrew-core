class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.6.2.tar.gz"
  sha256 "a4390258ef57135948aab39e9a0c0deed4f4be13eaa3cbac55aed8b499dfc394"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c4dc6810e38aa3fdda70f975a23000a96dd06c5a227d305905f7dad24707483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c4dc6810e38aa3fdda70f975a23000a96dd06c5a227d305905f7dad24707483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4dc6810e38aa3fdda70f975a23000a96dd06c5a227d305905f7dad24707483"
    sha256 cellar: :any_skip_relocation, sonoma:        "97914c11c3446b55d7dfc7dbdea8b86d8cc5fa1d87b0f54e8d5102337676c044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d786ab92d60e73936b995967d5c06c56527aa37ab18cd45a79b231414363a528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7918e3d4d7725421ef9c4158d8239d2e21049d87fc0a3358824249c409f2c2d6"
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
