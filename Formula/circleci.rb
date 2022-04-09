class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.17087",
      revision: "105d8f04375232291c19783576508e77e53b7ed7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08cb6219b219757b1109099a6b8cdeac4398acf1c7f3fef669daccc1efcd4e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c6182f6f3d3f34698e57160b924ce9357f0bf82088b0aa77bc4316bb51d6b2c"
    sha256 cellar: :any_skip_relocation, monterey:       "ef211d8d1e963aa191d4e11e2698bcd7d0277113f7fe296140ec15cb6b529c57"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c9954dd93968b21b212e1325a5fe9360e18497a072b6f0d3d9b4b911b2ad117"
    sha256 cellar: :any_skip_relocation, catalina:       "aa8747dd43f7a54b7a136341871286d2171a1c77d2c92a76d5e02ad9a3b18a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11291d682156fd122b56333230509b44c7454f4ec5fb9a149920f5ca10c511f2"
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
