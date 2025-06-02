class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.32145",
      revision: "8605aaa05a338254534eb5062b8859b3569c830c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7b87636a3e28a95bebe23613a172afa000293af94348031fcd3fb6859b2b12e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7b87636a3e28a95bebe23613a172afa000293af94348031fcd3fb6859b2b12e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b87636a3e28a95bebe23613a172afa000293af94348031fcd3fb6859b2b12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e536642d5bcbc1341e823184d58bf02ce92bb9e0ac851fded92c2881e7f3c5"
    sha256 cellar: :any_skip_relocation, ventura:       "b5e536642d5bcbc1341e823184d58bf02ce92bb9e0ac851fded92c2881e7f3c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13148d06a64c4089a37c13181aefb49cb30b96b5b41e8bfe4efef50cb5ec3d6a"
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
