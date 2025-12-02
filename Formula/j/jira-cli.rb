class JiraCli < Formula
  desc "Feature-rich interactive Jira CLI"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "6b1ecbd2228626cdc987548d8d83faae074c7a167cef737a9ac9180a03767154"
  license "MIT"
  head "https://github.com/ankitpokhrel/jira-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a790929543023d792e0547d539b303f4141c414e1308ea4b6ec29bf8e1b8f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38ddb622dcf18e8ebaec41c1c2d18fd1298a8e00e0e29cdd9c4a1a466d57bb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "772dd20a1ddfdd4073c82ca4715d1bf2580cc2e1da221b8bd52ae65a61fdff64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee1279968ff0b3a34f102a0bcd15b1ac98a66641794a15c018b6eb453413bacd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4d6654d25a445c48936e449877092ebf19a0689d5ae42c0209c87e27d17239a"
    sha256 cellar: :any_skip_relocation, ventura:       "c42cfff329d68f7279779f1b21a7e946b94de6efbe63e18a011d4f543039361e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e47438f11222771cb67f0d697882582dfa08c6d27d0e1f68216a6b1b1a1bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20b26f416c6706892e92db9bc495e5e195ef9ac4a9bbf805bf7807755900e0c"
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
