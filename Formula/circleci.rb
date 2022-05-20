class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18556",
      revision: "7c05b674b92fcb8c8b03cb4c43e9fa0fabdb6da8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af37137dbd7df5c25b20b5438a3d16ab0a0e99e85306593585b31f40850b5213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bd5ecab3c42cdff5f89ec19219e41c85b3b09ccaaf28c6ea75b1b247ebbced3"
    sha256 cellar: :any_skip_relocation, monterey:       "4a1711842045f591993e3910804bf82c9310a6ac8f0730f76337cd9981ac74ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a306ba74969753b76a87ce95f038e4dc5f5cfc9dada8295714cbf18454699044"
    sha256 cellar: :any_skip_relocation, catalina:       "aedb92801e3993f322a341aea4ab560d3c3b28260c4cd8f8a40a7193dc677765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9615108fe850a5dc1bcab13a16f9d78c3567b07dba112560dc7f1e840b0ba64"
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
