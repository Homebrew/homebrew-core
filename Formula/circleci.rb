class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20500",
      revision: "e042377324976cf0cf63b2b930369ac5b1ea634b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ad4982fbbbde849fe914d52dffe67946705c4b6fa7e3371a9d21a7390a68da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ae47c3a5a0bd85aa11abcc9820d8bd6e1521a945629fda735c0142c7a8175d2"
    sha256 cellar: :any_skip_relocation, monterey:       "51acc8623ed7e3077b7429a784dfab5a8236f58f3859f66e56b7770900288ac9"
    sha256 cellar: :any_skip_relocation, big_sur:        "afdc1027b9b1dd00e947b0719b41713513fd9e2c2782ff36281521810891d77c"
    sha256 cellar: :any_skip_relocation, catalina:       "f80623db4f6d1760dfc439bbaa5e3a04c2d2088d7ea33ac7938f92ce5b29ff07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b368e6e3bc84342fe6afda57127935aab9efbe62428e191c4f57271749694b"
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
