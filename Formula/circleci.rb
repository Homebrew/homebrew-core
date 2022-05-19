class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18532",
      revision: "5e6ca987d44c4901fece26415a933d17ce950ead"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d590f06563200f8ff6ff7f6a735cf459a7d4495bbb9b3da7a9322abbcce466ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fe8326e0e9c2ded0c67a36d309c1f23fb382a390f395e030ad5531b7db139b4"
    sha256 cellar: :any_skip_relocation, monterey:       "4eea40290548d10a01ee84be3b66609650d2ded5f114ae642cf97149af297c39"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa1ada7d2b62d58e395143adab5222288471753c89aa2baabd074e5f67a687e4"
    sha256 cellar: :any_skip_relocation, catalina:       "f8ac845c388d5024dafe76744c51be5e74d247fc0be45844f99b7c8926fba9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b273d4b7405aa5f36d09f5fccd1e176b6dd407b7f24ecb57566981df046409b"
  end

  # Bump to 1.18 when the x/sys dependency is updated upstream.
  depends_on "go@1.17" => :build
  depends_on "packr" => :build

  def install
    system "packr2", "--ignore-imports", "-v"

    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "bash")
    (bash_completion/"circleck").write output

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "zsh")
    (zsh_completion/"_circleci").write output
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
