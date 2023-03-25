class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25085",
      revision: "31c41779b61e9279deea29c819bfe5f17b26bd5b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df01d6c47a52f2f6fc74249be299a4ac1b3ad5063b28330f9a8d3b516ef6473b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df01d6c47a52f2f6fc74249be299a4ac1b3ad5063b28330f9a8d3b516ef6473b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df01d6c47a52f2f6fc74249be299a4ac1b3ad5063b28330f9a8d3b516ef6473b"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc093f0ce2417b86019d999cd4f36e72638dfd2d8f8afb3703c1137f8e8879a"
    sha256 cellar: :any_skip_relocation, monterey:       "9fc093f0ce2417b86019d999cd4f36e72638dfd2d8f8afb3703c1137f8e8879a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fc093f0ce2417b86019d999cd4f36e72638dfd2d8f8afb3703c1137f8e8879a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9fb9e2a397c58077c2433063ed0a29c91ff2896bd28a7bd2c56bcd23919981"
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
