class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16737",
      revision: "226bb7f294447be64e86e49d3a62c55a2b407c75"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d850cfeaaf14a322eb960f80419626dda042ffd37de84f401bb54c5506bf24d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddd0670a68ef4212157ac99807673351e2a53fb5a5503670d947d700e1748121"
    sha256 cellar: :any_skip_relocation, monterey:       "5eebeb9490e501fc09af148926e17db78c035d4c0dd6355057635648830ed628"
    sha256 cellar: :any_skip_relocation, big_sur:        "605494b2df8264780c99c880721146ad7adf1c0dc27a782eceb701d1333d3e8e"
    sha256 cellar: :any_skip_relocation, catalina:       "f70d0dc2a9b4d487d6f8ad68cb0c4d394c15be87b0877a64b257c237109b3464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94c9cf37962aa30ff89bced6cd35de50c3482009297137cefd3f4b7206560f0a"
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
