class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.7.0.tar.gz"
  sha256 "3e979349e116428e09731c2cf3f9d6607a146c6175ab07e39b312684620a2529"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df262c989248cb5463ab8bb508c129ccc4aed0aa388dd8d159c611957cb66100"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df262c989248cb5463ab8bb508c129ccc4aed0aa388dd8d159c611957cb66100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df262c989248cb5463ab8bb508c129ccc4aed0aa388dd8d159c611957cb66100"
    sha256 cellar: :any_skip_relocation, sonoma:        "2464a512b042621356c6e4a81127fb40bcca36f6d824f453a51a0f5a6d52faad"
    sha256 cellar: :any_skip_relocation, ventura:       "2464a512b042621356c6e4a81127fb40bcca36f6d824f453a51a0f5a6d52faad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57078423ae343aa88d2b92facb5041ea640e9009e1f489c79678649f538d5244"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")

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
