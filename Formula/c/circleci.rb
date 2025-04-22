class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.31543",
      revision: "5390914548a9937f3ef0d6d1070fbedcb162a4fc"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad623eddec17fdd6b50264f6be170eb80d4e6a8cb6dc76485a2dcc9a43f5b81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad623eddec17fdd6b50264f6be170eb80d4e6a8cb6dc76485a2dcc9a43f5b81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad623eddec17fdd6b50264f6be170eb80d4e6a8cb6dc76485a2dcc9a43f5b81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff7015d0268f8ce2adb918c792c46a8afe1c2aabb891be097d7f9536852e72db"
    sha256 cellar: :any_skip_relocation, ventura:       "ff7015d0268f8ce2adb918c792c46a8afe1c2aabb891be097d7f9536852e72db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf41e4802d824d483bbc0023aedcf2ed312672d90bb96d0bebb88dfcc8daa6f"
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
