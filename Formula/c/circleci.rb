class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.38646",
      revision: "f96353c6bb0085274f4061376e7c3ad719f265bc"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fdb2236dda01251a520b307ec0b92e48c232853dd46a9a319be15beb3814442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02f65671b801f3f6b7e6a5fa83a8acb47c80d2d1e031b367b3253c6d483912ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb19422042bd2dd55c1e3c6f3c5e11a45255160f8f3f3629a5e93e2a8291d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1f39e67fcb12360160f0b6ff7d3b7455fa0ecdf54b567df144a78ada1cde8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "819f3a248e632f3558d19608b6413c405e5d6027e1791c234e0448cd531949c8"
    sha256 cellar: :any,                 x86_64_linux:  "0ce55580d8ff8e0f54ebf64ba551af27d582039d24152bcd0a2fdd15179d1ab7"
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
