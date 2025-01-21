class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.31151",
      revision: "591d7b247869fc47c663fad2e756b9e45ca2a302"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7183aa43741eaf1215d725331567b28df0c3b79fe52300a71752e640fd7493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7183aa43741eaf1215d725331567b28df0c3b79fe52300a71752e640fd7493"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd7183aa43741eaf1215d725331567b28df0c3b79fe52300a71752e640fd7493"
    sha256 cellar: :any_skip_relocation, sonoma:        "348f51f93f629eb708d2c81c11d297a48d5967d4e297dcf0c9df34ed13ba1d47"
    sha256 cellar: :any_skip_relocation, ventura:       "348f51f93f629eb708d2c81c11d297a48d5967d4e297dcf0c9df34ed13ba1d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf2ab29b9d8d6418ddfbe1a26adb6d371ee623e3e6f86bc2f49c24531a5dae7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
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
