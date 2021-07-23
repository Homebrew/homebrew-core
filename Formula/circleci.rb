class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15528",
      revision: "45a6052d93cb48d1cafde85b6a38a63017b254da"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab1e40ded91bddd85f384b0b1ed4a5cfe7ffac11db7b59ed6bdef35fbf088a60"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c10f56f5c4788b8be57d51baf6aa35a403f3eb7b113f7ce91c97932022177f2"
    sha256 cellar: :any_skip_relocation, catalina:      "9f47b5b29f78d907e36db217d2895cd8e462b34142bd96fba61c41cf32802cca"
    sha256 cellar: :any_skip_relocation, mojave:        "929156fb9f0f1b8344c2eb8c080b6834ecf36d6aea7737db39636a5d063b3128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3df73ef5191e7df0a8380c343abe9a46624bcc44e8ca33bb883a3ee4c414193"
  end

  depends_on "go" => :build
  depends_on "packr" => :build

  def install
    system "packr2", "--ignore-imports", "-v"

    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))

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
