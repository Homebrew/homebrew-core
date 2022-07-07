class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19666",
      revision: "830e7ff35f9f199ddcb5e1a442d3240ad04d13ca"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d15149567d3bb33e4cc23da12219cf4a8f9a11a4bd969d2f4564fc7ca9b1be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "589c3c7defe0b50ea439ec5c59f447e949c99184ff37d5232f3af29c16bc31a0"
    sha256 cellar: :any_skip_relocation, monterey:       "1b050e62d9642d90c900bfa633c2c8da28272bc587fc1eafd5dbeacf873e02e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fbd5d3c6746a82003c2597cfdab11cfdf6d32249c2b2c33501d7fe09bf6cf95"
    sha256 cellar: :any_skip_relocation, catalina:       "35e843d7437856f4f5cc4fa4f8345f44346aa268198d506f89baa0b67e4125eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06db1491755f1c38ab03bf84528171a426a3dd2116d895c4d3cdd96e246cb652"
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
