class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15932",
      revision: "34716029c7a7520e711c21391940e4069cd38645"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28b702cac5bca027b19f1ab81727d65d81a77874b058cb9472194d5bcc30d979"
    sha256 cellar: :any_skip_relocation, big_sur:       "7caf1245ee4f39c05c1855fc9492e4e6ed585bc118f1e96ff2f31671a99d59cd"
    sha256 cellar: :any_skip_relocation, catalina:      "23545467c38ce622b90a1c519f5456f5a15d287cb2d9612cb5c6f51443f43a73"
    sha256 cellar: :any_skip_relocation, mojave:        "19d1eea527fdc398da4549892af304db8465c2aea2f080ebe98ed113737030bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54d3b86d8887cff917992e16709204eb9cd749094eb6446d7bb08066d23a4d6"
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
