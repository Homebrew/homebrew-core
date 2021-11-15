class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16225",
      revision: "8d5e389c1b2a6f134b145be6dbc804cf2f96aabd"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19435acff91a9797e10878dd13269d7c82e3e6d37642256dcf58de8d8b88980e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602aae23108f1e46075fe5c0e0e450daa1a69c880226c99e004969d98280f18b"
    sha256 cellar: :any_skip_relocation, monterey:       "432083f5a9c3d5ddcfcfa054a80534005ee0754dd5f1699d27fa7ad229c81b1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "24c68795c8f5e7da6d9d2714b93db02282f083929ecb0dbfc5e7c2775efc524c"
    sha256 cellar: :any_skip_relocation, catalina:       "51721f04b71bdda1b5228d358db02cb2602ccc8fd74e313853bd672b7518cb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3b8c07a5fe1e6d64527affd3c1b00985ffa3cc68ca9736d4d317ae409a4cc4"
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
