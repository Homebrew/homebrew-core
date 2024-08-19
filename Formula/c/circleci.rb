class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.30549",
      revision: "735ecd3c6f2f707563e5884ad54f9b000e60f28d"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b1f7d0ee4ad17170c153a0a2b772a8e121718b40be4c785bfb5e4889079fad7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f107f340ac3250063d5e0f003b1f58ea5d31174cd73968cdb98f5517698c0ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5846de423537b77322f70e73f0a3cf24b4049018940beb83d889ef0a02a33e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4cb1934f6d540f8e085ba380656ca17c6dfa093e78a9f819f5b37b713f43807"
    sha256 cellar: :any_skip_relocation, ventura:        "a903d8adc28d4fe1a6dca393c9334d0eca1665a3eae60b090fba95a9f075794d"
    sha256 cellar: :any_skip_relocation, monterey:       "c7969db147e35d8cc65404e6b2acc26c71b6e5c57b8813163370e822a527f875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc2e89939ca254b7052a13ca0c404308826c7aaedfaa7dec84e7bde31edca67"
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
