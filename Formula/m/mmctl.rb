class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.7.2.tar.gz"
  sha256 "edcc83075b768ed330a5f445a8b7109512fd5310427f5cc57e98d87a9f20b32b"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "856b0d23c611397e73fbb839f40763731cc5e5fcccc487527878292d7d22a8bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "856b0d23c611397e73fbb839f40763731cc5e5fcccc487527878292d7d22a8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "856b0d23c611397e73fbb839f40763731cc5e5fcccc487527878292d7d22a8bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "30062321341e6b481a8d6cdf4f32c00efbf2e5d14ffe8a644210754e56d33503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79623baefd64d40820e70858f8febba7e3e9f33246ad36ae022a903515f8bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d7edc0f0188da2671d10549575c908c139a964308dcf4e1e37684227900ee0"
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
