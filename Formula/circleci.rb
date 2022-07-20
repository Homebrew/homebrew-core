class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20144",
      revision: "52fb20927807eeb5ab069544e8154fa092c72644"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e17a970d09cb4eaef57ddebb5406dde905e3231f1196e21333fa467904be75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9eca83717279eab47097da4cb2e6b5f247ff0d18f94070c2875d8d45fd755a0"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8dd6fd91c11f624d48ea82aac789defe27d78c481de2851affabd527e78eb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "eef144295c04a9b2aeee0fed7cb004629b76113a054f88cd3fd970a13c9db438"
    sha256 cellar: :any_skip_relocation, catalina:       "667899c38e4b49e2fe20486f6ed9ad5ac307d4b409d31be9ba752a6abb157c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb175d88320f5302da18a53013f18d603598ed97ebaf35b5f7044804448961c3"
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
