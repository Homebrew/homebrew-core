class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.31632",
      revision: "d2e8a9679630e47ab673a36d62946e4204e5ae4c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87969ea9401db86c73bdcc6e2d9fadcc1af7f99112c2c2c81d41f86a28854e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87969ea9401db86c73bdcc6e2d9fadcc1af7f99112c2c2c81d41f86a28854e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87969ea9401db86c73bdcc6e2d9fadcc1af7f99112c2c2c81d41f86a28854e26"
    sha256 cellar: :any_skip_relocation, sonoma:        "2244f3ddb9d492dc7fef3d77c00bc7f955d66a635589c2778a05a77b86b60fd7"
    sha256 cellar: :any_skip_relocation, ventura:       "2244f3ddb9d492dc7fef3d77c00bc7f955d66a635589c2778a05a77b86b60fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d770e014766ec1603ea5f59a5a3bf717f3dae054861fa12690724125b7276877"
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
