class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.29658",
      revision: "dd6a5b1075f5ede623fffaae2433af0ca952fa5f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33e8d78dc375c20438dd632a95559d0f5a10026a1788904dc83ec9d16a3e877f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "413169d039f25bd031a0ae14587a01c4150ae3fc840711ed4bdc9d0f22e5a484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9470dd4134e57ce72d4a7a4ffaec8e3978f7f1d2953643cf2c51125d367f6ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3c3a0f294ea1cdd5a3faf3c0e2110c500cabe1a07e0cba9edadf5cab33f7d81"
    sha256 cellar: :any_skip_relocation, ventura:        "61d9e16a7287d42335d7ce94c42ef4093872a716f3cc1814b7163b174ee38714"
    sha256 cellar: :any_skip_relocation, monterey:       "b0db498f9468cfc0e204c6e9614bd2bf87801c3227d12a069d3c2549b14b3465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b69e58043999e0dbbb6a42672be60f2e9159d5712230cc1c94d693753d810ce"
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
