class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19183",
      revision: "cc194b572048e9d935aa7dc380e2b74bd3f1fb75"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a09e9a52d0be288de95839633deeaadb3a74b054d32db6dcc3aa2b45a0899bf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1d52da1a67d005f11c24b049f2b28c920c4d631b9f3141f12403058ef119dc1"
    sha256 cellar: :any_skip_relocation, monterey:       "99cd3fc0cfe614ed3b27b88cefd90355f22b4c8637f06b10f9787d8ce4dd37b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e74ccfbb64ce3b4b8dacd17fb3758ca9c7cdcf82dbc4e6ecb968aa138699e7"
    sha256 cellar: :any_skip_relocation, catalina:       "afa18ec742f5893c41ddf7eaba568b9f52fcebfe6ea6e1a8af9560c11ccd1447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9210f27f59c72511e93933e11959453018002894119764836246fcc480d8cc7a"
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
