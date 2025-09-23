class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.12.0.tar.gz"
  sha256 "46126594d5a8074c978cff3c8e1813a1bb788f7cb9fb0efb005f5334f44ab496"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab865f036afd3924924c274d7192eb66584ab3584a58934b4fe3a2f9de75da44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab865f036afd3924924c274d7192eb66584ab3584a58934b4fe3a2f9de75da44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab865f036afd3924924c274d7192eb66584ab3584a58934b4fe3a2f9de75da44"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bdc11474696c25280de6975f2626e108dcd7292f23d428461f7b51ba06a0f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4732c675431bae793e23c1a0549ef003440a49f931017bb28e87066d3882c70c"
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
