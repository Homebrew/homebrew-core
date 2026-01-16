class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.2.2.tar.gz"
  sha256 "4b35873246f832df2aee3755478b127ffc6a040a2411f64ad3c9b2e42e7b64ce"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b93de26188770c89e5f48b57ee354132180e28fe52a21bd03e42e2c4a7b8a627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93de26188770c89e5f48b57ee354132180e28fe52a21bd03e42e2c4a7b8a627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93de26188770c89e5f48b57ee354132180e28fe52a21bd03e42e2c4a7b8a627"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb80f64fc2ab0278be46e50bca00bd2c6d344b02ef75a7d1f008092418ae21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acbfd8c226ee0072ba42a51c3527af6845aa15f1fe196abbe2e20e4aa73675d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b133bed577289888600cf92a3e11e2b203bde05a4843a53a919d9b886ace20e"
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
