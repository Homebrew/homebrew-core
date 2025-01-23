class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.31425",
      revision: "ebcbd1fecb31a8537c3dec98b9c8c5dbe77da1d2"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f80efbb354a62e985c793bc94f2fb5e66c48b4e7a358c07fcc7e1d88d120fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f80efbb354a62e985c793bc94f2fb5e66c48b4e7a358c07fcc7e1d88d120fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63f80efbb354a62e985c793bc94f2fb5e66c48b4e7a358c07fcc7e1d88d120fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d255d2fcd5c4ccdf3cc217cb8a10a3e9841514b54a16dc369e2c8993408aa541"
    sha256 cellar: :any_skip_relocation, ventura:       "d255d2fcd5c4ccdf3cc217cb8a10a3e9841514b54a16dc369e2c8993408aa541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90038ceafa7a1652581218400519bea3fff891f218a78ce4b9b72b32dd52a6a9"
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
