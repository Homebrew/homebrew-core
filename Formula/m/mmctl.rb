class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.11.0.tar.gz"
  sha256 "b382caff73c9e65eb022d70ef7e14ad43c242861519315beaa956c7cb3628674"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a19ec95c55c6d16e1de99fcb9e8b9d7463fd5628e09b8762a2dabd37d565b1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a19ec95c55c6d16e1de99fcb9e8b9d7463fd5628e09b8762a2dabd37d565b1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4a19ec95c55c6d16e1de99fcb9e8b9d7463fd5628e09b8762a2dabd37d565b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77beeb88ee606a70ea138cf73b854977e7dc4459f62e5a6b01c70a40f222fe6f"
    sha256 cellar: :any,                 x86_64_linux:      "abe64c61ab7ab03c27d2269ad970a98f8f6d7ee684ad661d5c165ffe119acdf4"
  end

  depends_on "go" => :build

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
