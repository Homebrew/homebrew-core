class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22050",
      revision: "97049b800fb7eef5adb4135f698249b986f1388b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b741c149408c4fa9ed0c96344206f61e4d7a16c4e3f37d33d967bdfc5825b241"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd404fc5b6e879351ef06e648b8f2a68344db18356c0912bdf2febda78827b91"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3dc4a2599588109295a9b4cf3527b20f48e08920b98bef149301f9264543b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e52769c7a5ecff79b29bcd062331a968f11be73196252d936a762df0557e9b7"
    sha256 cellar: :any_skip_relocation, catalina:       "3f0afc5ee0ea97504469c4f97d5d901594be57946bef83e8308bd4127bf3479c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6d9ce7d0a031771549846627eac2c801e797d1d80170c58d10db5a67f429d87"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
