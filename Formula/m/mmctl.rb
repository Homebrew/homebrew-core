class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "40f95492b8032937a473ca449a460ce76fca575bbb959229def21d8fb81d7337"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f6d64cf351018f08fe24e22b691ae46960018f041b86fe213a3ebc0813ce6df"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f6d64cf351018f08fe24e22b691ae46960018f041b86fe213a3ebc0813ce6df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f6d64cf351018f08fe24e22b691ae46960018f041b86fe213a3ebc0813ce6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bff29827f93da33483a7df6647ca9a1cf278340eeed5a227375b7543c65b940a"
    sha256 cellar: :any,                 x86_64_linux:      "6ced562eaa2e194809a1d9185bf9c712870f757f8947ac192c34d51297332deb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "make", "-C", "server", "setup-go-work"
    system "go", "mod", "download", "-C", "server"
  end

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
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
