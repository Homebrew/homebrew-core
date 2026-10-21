class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "d6ed61dff7370baaf41d8b4baf8483472919ca5d3b03c6b638c4c9732bcf0617"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18d152ac9ca0e8051d2ee264ec80cbef0e516df228340dc22f2e33893ef80317"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18d152ac9ca0e8051d2ee264ec80cbef0e516df228340dc22f2e33893ef80317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18d152ac9ca0e8051d2ee264ec80cbef0e516df228340dc22f2e33893ef80317"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6fab84112c0af20b1d9020cc385c5b0e7a2bbcc78bb9815885d23b5064ef5edf"
    sha256 cellar: :any,                 x86_64_linux:      "cc5adfad68f80559e414c64925ed2ba4f79ab4a40f867c8fac5fd96e48ebb78d"
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
