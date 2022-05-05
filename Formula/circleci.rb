class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.17429",
      revision: "18585af7414a80633aade2f03f33d8ec5551c962"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe45875f748493b7555439458e1b758c96ac8fb94e38f54e46ec8d644c0d0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75234755c4b6a056a4dc6737479292bf36e8b9d5a81e7df0fbdc69f436b04295"
    sha256 cellar: :any_skip_relocation, monterey:       "60d99009941863aedd4aa0f57e43f8b56a2a71aa8084a971dd362eb1f29acc59"
    sha256 cellar: :any_skip_relocation, big_sur:        "75121d7ddfa3c626078df1409d9982289b22de58aef8d2295956b40799505924"
    sha256 cellar: :any_skip_relocation, catalina:       "d542aab9848f699b9c34f710c6dcc44e1ce4dc98a68a501ee2e859d9c6a7270e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b27b9a1a1569d0b26d83a6530c15f64bb7ce3a369f2e36b4b47c04ea502497df"
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
