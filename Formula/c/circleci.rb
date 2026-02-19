class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34422",
      revision: "befd62691cc471c296e6b98a07029ae55aeac62c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "492e73678a06fe7d11f6ee4dd1af0cf6b11edf8424959c70c2f3acee90a93d67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ed0a83f7a5734b6ce1506ead62349db1681d99ef870eadac46c3865b0b2b173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "851374955ae6b9bd89270d6f8520596aa431200d808421fd073192e86ef7807d"
    sha256 cellar: :any_skip_relocation, sonoma:        "570d33f11f21bf60e13f3c96076e8ffe26f008e8b0eb160b3df5b0323e4101a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc274f0d16ff284b72a6bc8e60f8f93175d56cddd52a93cb3077137426cb9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8eed794d0e0aaa31853d0c99c3b872da0e4df8c0ae5ce2de6ae0b7f30c5318e"
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
