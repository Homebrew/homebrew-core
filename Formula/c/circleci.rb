class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.36202",
      revision: "50a6f5685ea024c53fd11ed477742382cfbdaade"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1b073b841bb8ee909da68864f2a79bf0cc3fa2dcf1b8a2c3af32090726fa619"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "482500126ba2bf047ee33467e83c480a7d3cbac4e206f3af7767a7219f1e034d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f3c77a4ef60f323bb6be4c43271e0dc9fdfb4fdd702818bfdb8f6d393899ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a8f778bf75a4032ca2979369fb85812eed74856d7e2dad0030e75a80828fe31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cdc0fa6ae14afb3cc7233e782635f0fd095828a808455852c2fad81a629f83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da39d60c1bc6df02417922efbb0e486c67096a1dc5f72d084bc9a2809419d07"
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
