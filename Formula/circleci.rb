class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16737",
      revision: "226bb7f294447be64e86e49d3a62c55a2b407c75"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e78741e61042c89c51e6c0cf6cbe2e7ea550c328903e963e7650f0bd5e3acdc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a76e6f721930851504b5cd4f184fe67a278d93919f83996783fff14a5ed4180d"
    sha256 cellar: :any_skip_relocation, monterey:       "1da36033760dbf5ce28642d69f8d6ba1b761ad8455e5ba5fad04bc58872f356e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce3a5fcabc7d961f61dc6094c3a3ebaabd950afa3ff0cb4ecd7193746f92823f"
    sha256 cellar: :any_skip_relocation, catalina:       "e61e64d688f67f1c4fcf593d245f0af264b9397d1a1447d7d79f1f203b5b517a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3d7e748d860652455fede6eb971265f7bd10e506154d469e534d34ece641cd"
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
