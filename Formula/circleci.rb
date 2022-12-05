class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22770",
      revision: "802994bb588db994da3d625fe46acfb8c2268d37"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f000fe253b9876261f9815e340c699e4f9a83792633b55d8c4757a13b8c2cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d36c3d607556fb8b616ee6de3e1fcfba884fa09c3b560418d4c0ede7a13e3c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13a7701d65a203c2047011f55569f737d7bdcf528aeae85fad8b1660eff5dbe2"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5ff89a262387b5a137984af7aea36384a6ce36631675dd445a2b88ab19e0c0"
    sha256 cellar: :any_skip_relocation, monterey:       "430083664d5ba0e939c8467d45a7e4e1e08c28ecb146bda07f47dc7d5d0eecf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bbe76587580dfa769057653fe93250fcd060ff0c91abe89ffabb0177654f642"
    sha256 cellar: :any_skip_relocation, catalina:       "7e0744fa2863bcba4841701c412da69abfc7b7f03988f9d605529374baa2e251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d46979ba6a012e46f7b6d430b689e3016b1d6ae66a2b67bb239844feeacaa6"
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
