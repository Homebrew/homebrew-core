class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19836",
      revision: "f848adbb56b79fa62c209238001633f9c65a0ce6"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec1444fc50ffcd48fe6baff13435d56f645cb3a39a752d09f0b39eab41b8f3df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc9d18c78d5498e1d656ea3e1b02bed465a34cde675d1056d1a638fbbaf0b314"
    sha256 cellar: :any_skip_relocation, monterey:       "2f873ebf6f8e54f80c25428be15796ce06b8757bdd5b6cd501a6e1409c1b5940"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cae1fc69191af24bd0716ff65331978df9ee689433a4bb0549420ab7d916f0b"
    sha256 cellar: :any_skip_relocation, catalina:       "0045ff6b219c31c9048dfe34bee3d8f52efea2a233579453a476d3078d6278be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e466ef4daa7c61c5a3b43844fcb8dec8c80263c14e625de3c02ecde9ce64bb66"
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
