class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23489",
      revision: "901243e2ba1206e85a52f795a06748e8a951f559"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a3699ae5bbba74e1ce50ec3d5a66f374185cf07c74ebb130bfa962d2785f132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8e262f9a3f4ad52da57d38eb12fb35c0d7b4a37c189cd447617ab6f1947708e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a60b92687de7099625eefac8670e5013b86ce632d3af45fc7ab95d3361f8bb86"
    sha256 cellar: :any_skip_relocation, ventura:        "08f23eed1d55290f18d81f0541d7c01e7f55a924633457f5fb99d85499a4e723"
    sha256 cellar: :any_skip_relocation, monterey:       "480297a206a815307419032e4a92c8a46cf7230fe9482a7040a6e534f77151e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c214220d2e092ec5802eafabf920197372d905ec24b5f4a2ad11abf79c4eec3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee6228c6e2dfc23b7f3bc5d0c5bde3d8a06456db78617de96fc92bf6229408d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
