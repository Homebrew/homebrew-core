class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16225",
      revision: "8d5e389c1b2a6f134b145be6dbc804cf2f96aabd"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04bde5de8a510ab4e1b2d97e29aacb0567a530a756ed48b090ae2b09b8ad3111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cacdcbdb1f4774deaee52c3d50a44a239a322a6f9d07aee9d8bb08cbc3b8ee16"
    sha256 cellar: :any_skip_relocation, monterey:       "f1cfc430e0d3c9f8136c0a2cb65696c22069f718e83db805a746cf9efce418a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c022d7b40f76566076d3f8e2b5994eb00393d3968ca428dba9a87d5726ee218"
    sha256 cellar: :any_skip_relocation, catalina:       "18d56dcc3262018461ea67ae256a1f0ffed02acbef892af1f029b1ea18cd6e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62618bb213f3d22c35bcf1831dab318915228dccb7a1f2a470435e6a2d61ef88"
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
