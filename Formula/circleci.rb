class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28434",
      revision: "55236583a42bf63947b87055e56a571141e15a25"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d38d0cccb8afb37af45dba17dde3c68a0dace64eb69a68a41a470254530456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9d38d0cccb8afb37af45dba17dde3c68a0dace64eb69a68a41a470254530456"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d38d0cccb8afb37af45dba17dde3c68a0dace64eb69a68a41a470254530456"
    sha256 cellar: :any_skip_relocation, ventura:        "2ff0011800bcb9960f40b436e1c7703d0ddc5b1b2fd7d1600e00b33f19d893d3"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff0011800bcb9960f40b436e1c7703d0ddc5b1b2fd7d1600e00b33f19d893d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ff0011800bcb9960f40b436e1c7703d0ddc5b1b2fd7d1600e00b33f19d893d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "790c8459258fcddb62e4845b4e67f11cf54fa2fea2ff09e4502cd92df48ca5ce"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
