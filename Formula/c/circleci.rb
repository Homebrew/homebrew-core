class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34038",
      revision: "3fea9463e8b9367ff96a65a87677c6a1788c75e7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ef573f9b0501949be55f4a0eb269c9c82dcbadaa305a90f6d8071e756a69b1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63292ce18b575da1adefaf26eb7692ab67db97ee4988da8fc89444ea806ad2d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bea6f28d18f2373b01fc715844c735e5041e6c6fb9ef9f67fc1a2b9d3c027bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b507a072931fa9a565da0469faa93dee9b71080be6d7bf96846015707a386612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dec08ca47ee437edbdd73cdad34cea51349a7e53927597f1d62bda62222025a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a581fb8d0e85b3f91d17039958518d68c401dea915542ebb209697fc7e8968bc"
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
