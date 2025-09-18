class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.33163",
      revision: "b0dfb51968357e70919b31ada769f5aa60886ad3"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee6957376564ef91332c76d02c463a767db1b674dedef8e11355d68a04039658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c436f28daabb3aee5127789c0fa2c8415bb7851d7cc6fd03a34dfa0c5bb0b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5201561af872aa6ddc75430ade6f818d3f86674a75458991e632a9f7165f4af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71ea9d000b45bf538b72170173ea25387acf2873e73640306f872e3713a42db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "41dcc416d4cdb509d915ce6b467d9ac7c5c7b56985f2926267f3210403993304"
    sha256 cellar: :any_skip_relocation, ventura:       "2a53da67dd809a9e4be171e2c022e75b081fa08d5fb158e4a03c1e4548a057c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a195e508cfcdc26b258e4f6b8c5ac4c8d2558f350e1c437e78d8c62218eecc"
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
