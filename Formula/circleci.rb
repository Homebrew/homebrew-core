class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18305",
      revision: "60f56cc1696a4100dab038b6c54971c66c1b8979"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0487f94d6b6431b2ed76bdf922671d6638511f4fac5bfd223a77efafc1c79c85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90ba50c6086c8801002bfe6557e292cb262d6c83c4ceed14c96e6420170bd704"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c7ac67c6f9ccd755ca9321b3f3c2f718fb628319cbda1225e112b43e6aa87f"
    sha256 cellar: :any_skip_relocation, big_sur:        "57f5c9ae958f9af677a8beb5d334a539ed81c2089b7bf524702a8d324b429445"
    sha256 cellar: :any_skip_relocation, catalina:       "4b1f33838372650f8f76dcefe7eaa9b1b821cca2e30b28f3b64a96864dd7fa92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee60746d7ca17a80ed9d4d0860ba32476f27128f4840a99447a0e7c805ea7ad2"
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
