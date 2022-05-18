class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18446",
      revision: "af626c38c57a014119aad8387e671ae0657b0838"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447a35a101af18c4b3022ebc8d00031e5335b4c9cce490f3a4ca162d1ee9bf2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1457170b6b4bca81a99388012abaf8e4511992022eafc9f270124af99c98d70"
    sha256 cellar: :any_skip_relocation, monterey:       "287ff0c738d027a4cd5ad42517e88bfcbffafcbb9443d8a2ca4d03e82dc8d2e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b23adc21fd38328c26964256045c41914c64c984d8d36e77c8d79e0a8b24fd1"
    sha256 cellar: :any_skip_relocation, catalina:       "b1c668fd410ecf27ef289538861c5280859e586b3e68f0d4993458b233a8548a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb8743bf08f4f036742d24d6314c824cb00ef0163f852f85ac86050cc87e835"
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
