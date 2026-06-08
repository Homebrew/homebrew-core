class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.107.0.tar.gz"
  sha256 "a1549c174dd21c5c27d18473a0da5143492445db9ef1a4f955b026ae2bcc2a36"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ae51ca4e91ab8316443c4d28fc98c591888a9a2863c41614db2936a97e910df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ae51ca4e91ab8316443c4d28fc98c591888a9a2863c41614db2936a97e910df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ae51ca4e91ab8316443c4d28fc98c591888a9a2863c41614db2936a97e910df"
    sha256 cellar: :any_skip_relocation, sonoma:        "fced238c10c9296af839d7d43420a742f997e9e9a2c022254dcdfe94657bf265"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac57537de1fb0e5e4fc177dbc50cb1d82a91c72770d81b34cc0d29b879ee216"
    sha256 cellar: :any,                 x86_64_linux:  "4e1e58cde334aafffedc6b85be067ab0678e3f232869e0cd5ad48ffc6bd736b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
