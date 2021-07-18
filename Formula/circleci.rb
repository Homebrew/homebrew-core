class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15410",
      revision: "ba6fe81ece6b6d70ce4788dea3de1d8981234319"
  license "MIT"
  revision 1
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3004e164839cc0215ed249a58f51f39250430153af7d9840677679cad3d66ade"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec696c44c1fa9a3c351f63da60b524b4801f5a8b91e8a89cec36abb6eeb49ce6"
    sha256 cellar: :any_skip_relocation, catalina:      "6d0fc192edf2af07b559caad0188084da339629b9f5fb7d469d759be99f1d0ba"
    sha256 cellar: :any_skip_relocation, mojave:        "783766866d1f618591b5926979f546406349bbf66f6bc0c8a4f4a2a35c0ea7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44568a5576b1f343bae42e308be46fd258b9a37c12401782849c2b88d24761c4"
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
