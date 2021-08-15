class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15824",
      revision: "effcb62fd73da19505931e9e29f77a734eaa60da"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74b66081d5a879a0465777fa3b8f11ddeaa4dc1e5a35485a0893d5080c3c770e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ef8193e3f6a86e4c0a59c8c9688644548190b75538cf45dbbe5903154cf89c7"
    sha256 cellar: :any_skip_relocation, catalina:      "7f35268abf657fe66258c2f2765eaad00cc0d274c09083edfa712d8b2b7361a0"
    sha256 cellar: :any_skip_relocation, mojave:        "95df0c2972b0539e45a6c8bc727dade56af5b7a05545e4a474efd93aabc3033e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c7eab6e8e6e2b939c35581f57701e5787a1617f8f9ec6e3e267f46f76b8b80"
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
