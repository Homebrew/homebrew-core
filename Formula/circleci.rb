class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18894",
      revision: "479631bf822bb061e2efc43f7aeefa7e899fbbd8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b3a0951115e229e0e26c266250423fe0230fea0b312d002c1c68ef9b670eb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b310d00ecdd3277e4bf9d07f45b97c8cc7b52343b3753fb9b308c5459776d38"
    sha256 cellar: :any_skip_relocation, monterey:       "40e6b2593eb8a99c51700ca800c6b059952580343d673c20995436f007fad3ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bea373b0b3d42cc4e7c2f2e461406e3385892d9d55995f02865f9a991c78a01"
    sha256 cellar: :any_skip_relocation, catalina:       "ae15990f128e518266fd4012694a2299d995bee1d5c8dded307b2a8dc895af0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd0a43b635f99b46292675263b708b3f952d00a8f950243a138b858711067ab0"
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
