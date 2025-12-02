class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.33826",
      revision: "5fa3c151f3c492119baeeab328c9a47aca34bba9"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e14b04a183493e0b3d02de4cbb980c976301bf5ae3d315cc99c4fffd01a352d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bc79ee73014d234100161eb653ce443364be9268f205d61c132d7c917d422a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39e5d1fd316108604b462deef31a357b04e36af28a74e9dcf21915e7c1f189b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b393a10394394dd2974d710c319416ce87aeb1ac5c0b30618a3818675076668f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06a978e239c935d8ad23a2900ed4560fd5e9422a9eedca54f9253aa531e2515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f43d97129c47e5dbaad9337b89ef61923fd4f8c8990b2e1c57043053a5f78fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

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
