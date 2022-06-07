class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18828",
      revision: "e96ff599fd236c5ec0e81a77649a3bf4a9ab8849"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e85edca518d72557e658613b86c5dc05105c2d1c08bee3ae5c5c1565e2240d67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a01b3456984a315f7cc38a03c970424f044c5a3d67855054f8704af608e88579"
    sha256 cellar: :any_skip_relocation, monterey:       "9dc7133ac2d9e43f1f20a80325b59d6bd1d27c62b9602f06b012a3ea34b0d790"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f65a138f554d7f4a545069c315cbec9e20416e6ab72e913b5210f48fe2dbbdc"
    sha256 cellar: :any_skip_relocation, catalina:       "2f13a10cc979124d7315b728b2f373aadee72a30858a5de5f25f649c43ce97ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266c7af3bc3d89db386aac233b9f55c23883c2119e5c58391b6042ea901afe1a"
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
