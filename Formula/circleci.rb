class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16122",
      revision: "a170bd39a6dc250aae15394d0b0cac2b4bded34b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "014e4ad0dec296fefef9ff293f80c23daba3e9c74f46a1ee853658d9e82926ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "e637eb1ac4fd662c77750eacdb215185d8f5195be38a0bd34270a223e218ef11"
    sha256 cellar: :any_skip_relocation, catalina:      "2f7c25ead1ed32f6a3f8c6bc026fcab90f471a61556e20117d46d5c1703aca49"
    sha256 cellar: :any_skip_relocation, mojave:        "0f1aae72d0c3132cdbbdd8c43b26f55f59dd3b3119756b9c40c6b52d97bfa3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e03d7054c684309d1b6a7ccf3b1fc3ca3640ead52bc32f6e1b0dddf081b165e2"
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
