class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23489",
      revision: "901243e2ba1206e85a52f795a06748e8a951f559"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3912f612ab2f72b1591dcf391b8ecd0e87ad5adcf0759630e172bce4d9e28d5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f9d888dde3c1ed37440421619e1353fa676d4cab1e0cdb5a56e9dca69ada908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a7786fc9284187a1b77045293953a0972df37bdceaea337cad0e1235509a8b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c25f67ba2e3042f3a034815a9157b4f979f1de97fc19edcb90f1df0ba9739d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "6a100ca66d110d0863742c6e3346819c113b264f6477b78cf2d67fde90d3cd3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e0094bbdce96206333f7340473f0ef617459da3956ec085436f04b4506262c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669bcb25be266a3a3a4d4a4c94f3e38543f2b528f5c2a5d8892ea0bd1234d10b"
  end

  depends_on "go" => :build

  def install
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
