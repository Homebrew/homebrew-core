class JiraCli < Formula
  desc "Feature-rich interactive Jira CLI"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "89989534ae3f254be7a13dde51bfcf1c58f36cbf26ad3de9e333ead36579c007"
  license "MIT"
  head "https://github.com/ankitpokhrel/jira-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8250d45b6be6e7f897d704248a10ce708fc0987b499f634b483452046ad4074a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "826e1dd2a64baab107b3447068ec9a61dd59e0f59155a26c5eb85b38d78cf9e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4355e65a165d7a3266454843f6d94ff14457e3e7206aca7da56ab073759eee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e8948a461c557c4907131efb2f052a215c8e7b205b3294bbc1d148a84eb4e92"
    sha256 cellar: :any_skip_relocation, ventura:       "59ac40e5f7e4e2b5d53ee7a64c7c3d49e55fff62b26eee766351252e616c2144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c56844f974a3625d3ecd9ff4fc37aadb196c691511f701e101db611d944f74fd"
  end

  depends_on "go" => :build

  conflicts_with "go-jira", because: "both install `jira` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ankitpokhrel/jira-cli/internal/version.Version=#{version}
      -X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=#{tap.user}
      -X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=#{time.to_i}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jira"), "./cmd/jira"

    generate_completions_from_executable(bin/"jira", "completion")
    (man7/"jira.7").write Utils.safe_popen_read(bin/"jira", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jira version")

    output = shell_output("#{bin}/jira serverinfo 2>&1", 1)
    assert_match "The tool needs a Jira API token to function", output
  end
end
