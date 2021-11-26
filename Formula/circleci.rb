class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16508",
      revision: "e367219b143da38edbdf1d4f5d7a4f7209658126"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b721e12a1a9416c24153d4c702c8e3851f20ec209d60b5280033c6a126d75da8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdff28d461ba14b54c870b888c12e5002c62ac03c29c400283d58f1946f66eea"
    sha256 cellar: :any_skip_relocation, monterey:       "b3bfe5a0be1da5c16b1c7ec718e1fdd54c6974c990e7146b5b42b8a08b041539"
    sha256 cellar: :any_skip_relocation, big_sur:        "a93332e71353ecb022c494b84376e46fd96c743deff69fcd126f57a7d561d24f"
    sha256 cellar: :any_skip_relocation, catalina:       "f52e1aae3cb0171a1d79ed5295f3236654edf25c07273c20c9b647693ef3013d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2c04f4a634baec9a70aa252f540fead7d41a6a843a7f2c781cfbe228096d9c"
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
