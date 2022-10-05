class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22100",
      revision: "a77d125a39c89a92718c41eb2353cdec5907007d"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7f29713e6057f4dd58004175dec1b38f80675ccd09e52f048ce19380defcae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e7f747472674e2886a0c733a2ee745e0bf51a5eb21201673f82949907e282b"
    sha256 cellar: :any_skip_relocation, monterey:       "e4620263b28745c3465f75dd3f1aba2546c9f278c7b7f25a76c838c87a24eaca"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b516be16a3be838a7699bfc9ea26b4182d252da4b2735319346f79da16f2996"
    sha256 cellar: :any_skip_relocation, catalina:       "2b24671452c0cc9906a288fb5c7cfc6ba29cd15d17f3bf0d9bf7362673a52eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc501358b4290abcdab1f93f0164fb31e285f15a5295d55534a1ef1253012a7d"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
