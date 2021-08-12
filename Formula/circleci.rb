class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15663",
      revision: "6ec121d68a6b12f46c604cc0f44d1e18d8bb2b52"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72d3e0af0fb0c5ac05207196d6597df12be4907888c654ef18fc6bdf46ddd364"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b4229fb0310285908ea35be0d92a032b79cbe80908200c97bf8c18aee344676"
    sha256 cellar: :any_skip_relocation, catalina:      "b91423449eb4d06280d7567044aaa619aab2b987f7e71231420de623e0fde334"
    sha256 cellar: :any_skip_relocation, mojave:        "6e4eec4ecceaf35d2792d327b24062d88ae22de98fbbdc92d81025980fac2159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2f8980a3cc8fddbbcd63ef6f0d730c8e349f70be9adf96f239ba461f085fe5"
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
