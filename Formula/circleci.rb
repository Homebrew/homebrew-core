class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18869",
      revision: "f5ffef7737272d19e697d0312226d2029a009de3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94fb7ea00d3ed136fd27bffa7dc3bf67a82ee3979cc44613c948664c0e63d061"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b24328b36728ad2b203913c24c643ceda733e1495b7e02321411a017126312eb"
    sha256 cellar: :any_skip_relocation, monterey:       "159c1a60667ae53fda3bf4ecb8aa1aeee1f59ddd16c93bb75a7778daf11e7083"
    sha256 cellar: :any_skip_relocation, big_sur:        "caae533540ed5c40146442728af976a528f8464c783dec50816e76ea6eaf3616"
    sha256 cellar: :any_skip_relocation, catalina:       "412e58a6c6ff891ba9e7dc81ec0526d72110154c49356d2160bf222958920281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda45200e6094d00632821281ac61732af8d4fef6190e8e5bc32651fbbe9d057"
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
