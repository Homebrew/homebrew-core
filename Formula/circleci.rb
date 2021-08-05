class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15630",
      revision: "ba9cd22132754133445acf23dcd093460dcc2175"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffafbd010d4d807716d0debffe02b40edc2949c4c8ea2c99b72056c456a77dcd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9dcb9359b1dfc71e27bea84bf75d09760821be45fca06bc94ca5ab4308c5aad"
    sha256 cellar: :any_skip_relocation, catalina:      "5b427c30b615122831a72b89f8c0ac656ff0f57e09058f579dc9736c2cdec81c"
    sha256 cellar: :any_skip_relocation, mojave:        "31e3d4771e0636afbbdd8f5de7b1dcb6973f4986962cb742bce2a34253af6d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367e4d2ecbaba09622d66189e885fcd40f6bd59d816b68148e100e846b854272"
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
