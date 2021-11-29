class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16508",
      revision: "e367219b143da38edbdf1d4f5d7a4f7209658126"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ed8fd2f5dadc5a4400ed93da8ff7dd2662c4a2be60348a319550ab0ab3e18b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "455c015107905ad43f0a29f07ab5008f8e00de617e99126fafb61283eeb81384"
    sha256 cellar: :any_skip_relocation, monterey:       "81ebbfdb80001ede714eb552a6fb7a0dd52c1c25ecacb6be9e26bd212bd119b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9f79e52380be5b6294c1f1727d94ad344cb127eea9cdb60121c2ddb13857a48"
    sha256 cellar: :any_skip_relocation, catalina:       "ec6528c5df8f18518c1d0271e9bd0ed97afdf2062ccb9ecc5eb00c7c23cc71f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5837c79f0b9da2df7689cff264fe6c07cef26265564d5a6804c548968bf39718"
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
