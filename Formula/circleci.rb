class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19626",
      revision: "655d06503f783e26968068b9cf165cc92a31ec68"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55af1534f199505aaeb4bdadb7ecad7444bd1ae727b55eecf3a2ba29ff94fb7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c1b6b05ecb7ee32d1b9c29f496f92808fdd625ea59d777821bfdca0cf483251"
    sha256 cellar: :any_skip_relocation, monterey:       "c1bf4187ebd0d55265bce0821529f624c9c5f9b4b4948a50a52663af8276dcd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "96cacf02c4ad6b4cdb9a264e0fa390158464e67ea93a175eb06d765974906070"
    sha256 cellar: :any_skip_relocation, catalina:       "d35713dde811ca1547690d4656438336e93ae904efc9062b402369e198a91148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc4990cbe9a3f180e46886b1534152dfcbc2e8fae1f10b627db36a38f9f71b2"
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
