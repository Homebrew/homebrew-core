class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.35213",
      revision: "1cbd2542e036e2aa13f775ea5e2e461b6a76ffcf"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "beedb43dba63c1829749cff797a543b74770629fc023b17cc5c43dc9c68f0f86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "142ff782aeec0ee8eb859f07d912f89ee9ad31c5368290c3b6ca779fd49471e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6454b01dcb206f0567bd4efa2dc795d43dc5d736790ed6a9bd98601ab3a823"
    sha256 cellar: :any_skip_relocation, sonoma:        "327543e7ef8c26e758c7a023da090c7d407e47518376086a49bf75f491e9563b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9645a6b69e42befe1af8abfabd8aaac5367505d52de6c7309cdb78e10c8db6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7e1ca229d3b00dca43c29d1c2d84809ad6cd1f30d9bf11c3eb600533db2aee"
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
