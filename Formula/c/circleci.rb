class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.33721",
      revision: "340a1059a410fdb62f5815de25ae6f1de69a6674"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e88a554607702f2bd8103ea801aa6687a0b4373fd8f2101225449e235669ca9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e3b071e0cc782350b1c34c86e56c33915defcc092be849e3ddc92bf63758ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a16f04844cfe2a3636499fbbde84e679d43600e22757174d7081692eaaeddb3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c70d6ae02fcd3bb2c6a386bebc5d43f522db72463a836bd47eac054c48c29ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ed09466744e8e2879f171ba46344fb5ce7fd6803cb999a62ab688159c46965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7beeb5f3b1e7bb9c281cbe926db4627e48cbbe46cbf846c45074169af1034e"
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
