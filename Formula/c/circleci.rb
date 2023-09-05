class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.28995",
      revision: "636da775cb1afdb288282d6fff4a87cbf60e10e8"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "847b04f5895e819893b0f0912176155bddb5949fb1b12a9387e9728e9a05a4c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b19cfd8c8fe39ea360e0251aaf879f7bfc8d8d65165d2161b07915d9ce8c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5663cb37d4d4a067823ff371a918c34042aee7401d2b2dc27e612d11d7b5cd8"
    sha256 cellar: :any_skip_relocation, ventura:        "1c3a440e4a54d4d7d4f4a9557ec7e2db67a97e04d7c8da7fa2de814b80974690"
    sha256 cellar: :any_skip_relocation, monterey:       "49065419567487646f7f85719ff2e5cc1067514a9215a60d787b7cdb0b9ec163"
    sha256 cellar: :any_skip_relocation, big_sur:        "4395c2191c63e55f6ab9c5e9c37601e9d0ad6057c82a631633cbad6a01eda945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "818e3a4b2a38bcf0ad1d678e06a2d36f21bd6041f6812cb7bd10554fa0544222"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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
