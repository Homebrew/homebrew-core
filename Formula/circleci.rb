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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb282e6004813187947e3748bcdf1d9edeccd320ec0d7085abcd3f79cf994dcb"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5aeeba6fbcf1eb553bbdef478fc1033a146ab877517518f91f3bb7592bbcc89"
    sha256 cellar: :any_skip_relocation, catalina:      "b1733d06d396fcf7ffd28fe79d3d60cc2e3330d31de3f566a4ea44dc4d1d6fd2"
    sha256 cellar: :any_skip_relocation, mojave:        "e3c52396351f7f89afa16f6dcc86e27c86a4d4c512f0357303efd271763977ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddce47140796be75571d225a9be9bed3c6d6766bef39d6263a7877e252855089"
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
