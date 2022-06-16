class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18980",
      revision: "a65cbb5d5d6df7d78628d241ffeb9c9e0c1d23d5"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d074ebecf563fe8e988cd37eba487fea1efc480b37963e2f27a029006a4c5c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9909655c681ec2182c0f4748425b89d678f1f92dca99e69f6efc983bd3dae1e0"
    sha256 cellar: :any_skip_relocation, monterey:       "3037b909a75ff13e554fe92202604433f5490311572b556119dbf5d05ed6e5a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bd48c7931266b7bc425e570019d7ba3f3c7f1bc138b4515d2cde54b67c8bbcd"
    sha256 cellar: :any_skip_relocation, catalina:       "8bf20f6d8b65562fd858ed0e80cf628d04ef257cabddedeb6e94f0f3c0c810dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4db53c57c676f95c740b1be74af3bdf08ad023f322216bdbb964b559cb02cd"
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
