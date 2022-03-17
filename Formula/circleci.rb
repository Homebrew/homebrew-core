class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16947",
      revision: "263902a029db53bbd869afddc0254c060c0fb42d"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e161aa485555afd18941d4984ff3208c17623ddf1057c99d81320cf85082fbdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f395d67c17fc715998c7bafdf8d2899902a23db65905edd6337ed3d69ce74b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a7fef9142182e508713b70d01dae856af2b5564f7831ad210e611cdd090f0dbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "604c3b59ce755d8c97264b9b6d3a798ea592fad40ee31156030fd9e254064164"
    sha256 cellar: :any_skip_relocation, catalina:       "b49d9ba1647f071fb222515ad96e260a4c32f02c6a31a30e7bcdb079b613b43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae104a61e6195e6ed2eb0fe7d2d7e118cff6889827700cb7bf42939d0bcf010"
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
