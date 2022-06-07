class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18828",
      revision: "e96ff599fd236c5ec0e81a77649a3bf4a9ab8849"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2213d973d0312021f29fc7df5a626543f1cbb4f0f8d4ffc40f55f80070f1426f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31395a95832a1e06aa1534e918460e382354fa7f46288fa4872d30cffc8b097f"
    sha256 cellar: :any_skip_relocation, monterey:       "92e9acd0edb2c00abc6e09c803d62af34328a382bb907fd9f344b6aef575ec18"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9383a181beb44e6cd0964f5ca52baa2deb2e5f53114cf9e602945e84541b868"
    sha256 cellar: :any_skip_relocation, catalina:       "9a0584885d5afe86c536bb3331d57ab007b039b13d67337b9fd04dbf15795bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec80d308f07a67743f6302063535b3a5d0ea51168df56a49f98c9ff4192d68b8"
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
