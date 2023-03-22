class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.24783",
      revision: "93e3e615d875040b1db382d067844249a42c575a"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e64266cdd58800d397d4fcdf72f010249414eb0b96101dc36ba0853dec385af3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e64266cdd58800d397d4fcdf72f010249414eb0b96101dc36ba0853dec385af3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e64266cdd58800d397d4fcdf72f010249414eb0b96101dc36ba0853dec385af3"
    sha256 cellar: :any_skip_relocation, ventura:        "aede5cd96da3c60fd210f6bf52d42ce236ab313e89a1d076a5927b3e8b853adb"
    sha256 cellar: :any_skip_relocation, monterey:       "aede5cd96da3c60fd210f6bf52d42ce236ab313e89a1d076a5927b3e8b853adb"
    sha256 cellar: :any_skip_relocation, big_sur:        "aede5cd96da3c60fd210f6bf52d42ce236ab313e89a1d076a5927b3e8b853adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324bf8f6a0ef19d01fdb7bacd03789d12aadf5337a26b2b7f1b11b8092420d49"
  end

  depends_on "go" => :build

  def install
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
