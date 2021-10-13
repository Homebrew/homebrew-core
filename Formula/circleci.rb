class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16122",
      revision: "a170bd39a6dc250aae15394d0b0cac2b4bded34b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b73e0c269b90c7e685cfe6a33a4391694a19955ec3655dad95dd51ce1d3bf0cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "693c42831d95715071c26255539e569c84a1ddd15b2652bcb24bca6344df281f"
    sha256 cellar: :any_skip_relocation, catalina:      "605e1fc7b4a68728935caf1d8f67853628e0f098f0c35190e3120e7ba69fd03a"
    sha256 cellar: :any_skip_relocation, mojave:        "cf9349773bd298cbbb614b6e648436c85913f10c93c9bd7e3a3e35dbd72e366d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71987e9d4a8b54ef313fbd28af08fee6a1b842025cfefb9a622831d64169fa37"
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
