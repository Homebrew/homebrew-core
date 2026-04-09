class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34950",
      revision: "8ff907b09a4a568ed92a8b5d0036ceae5e3eefdb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd3a617c784ff0aaae7c931765e30767b05ec4d543c99db3938d21a81a8a9fb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36a73bcedb3dcd31363a68de1b3f64961ab0ecda43b707afc5cedc1c79590f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dddaf42dcb4551164c2e27fa9f4d1ac1599cd4c58fe591b73069fb8e8cdb2a1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "00963b28dc8f0151e90ac6602a8bb4d12a692906838d130f0fb41a1e64be15f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de0b2ea76fa122a9260cba2e197fc58efea9e3ef9a86f9a11c27afea0d0f0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9addcb1d1f707439992e13b7aee43f7d52f0bc101b3ceb08b8eac413c987b211"
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
