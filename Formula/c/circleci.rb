class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28811",
      revision: "b8e132d73d997d28a56e1ad4a20a5bc0ba4c5935"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed2437cb704190c844973ffd83ff003287337bc58a0e10db710e11bc152e866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fed2437cb704190c844973ffd83ff003287337bc58a0e10db710e11bc152e866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fed2437cb704190c844973ffd83ff003287337bc58a0e10db710e11bc152e866"
    sha256 cellar: :any_skip_relocation, ventura:        "82d38043a9d218ffb20afdcf6c94c4d670046990a9b598751df0572635c2c69c"
    sha256 cellar: :any_skip_relocation, monterey:       "82d38043a9d218ffb20afdcf6c94c4d670046990a9b598751df0572635c2c69c"
    sha256 cellar: :any_skip_relocation, big_sur:        "82d38043a9d218ffb20afdcf6c94c4d670046990a9b598751df0572635c2c69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61f23dcfe80e82a333e227918f69938ddec7b566529516c197ed28c0e2142f7f"
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
