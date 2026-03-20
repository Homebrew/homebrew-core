class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34770",
      revision: "49672ea91708f87877368a85f56e5e04c459a428"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63be07ccbbf07837e4439b1f7b07eee1740e5da0a60aa64ac6fafc8c05288fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5de0baee643fded9b1bde0af1989e46c6e8abade96a3a827653d786defdbda13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81082989a66a4647dfe7d75cc490791fffa4577a610933df8a192b65c8317390"
    sha256 cellar: :any_skip_relocation, sonoma:        "933656e74d7b47cc46c1c07668090135676ba727e171f3b6dd1215424b225b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84af66b02c6a96047833f53fabcbbfac19736f8aed712d5cca89576101138448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d002cb19c616c890fe74987348f82436594fee9df483c82f922a614c8721f94e"
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
