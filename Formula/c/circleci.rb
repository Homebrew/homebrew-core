class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.33494",
      revision: "7cc65701e3bd9e1732fe5e449b5929f1e5f04618"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3530f1cfb9fb2eae631a668f97a12da2b3350f0f4e59a1417b54f8a83c061865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4960ec4f4ae3f47d6eb20c489169d6e7af4e0c4c2ed3b10b019f9e50e2aaff51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534c268c21763f97dc58981753d1d0cc593ef090a4e6ac48c55589acb7beb0ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "6477db3c9c4d5fdab400d51617836d1ad5e67c07580760f754d7f55f96af3f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a132d97bf7b3e565a5c3a0b649cce62126f12bc220f666aeef8559fe03af25de"
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
