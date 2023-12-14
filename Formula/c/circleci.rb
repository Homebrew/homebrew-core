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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bffe7a2b57df40ba507d2203f200a4d4583b9c1880d14207fb9634308071a489"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a713efe95aeff8f976918094919e69d242bd58a9660ecc658db907f863c9d454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63318cfa0387d801cc07a59305383f73ebd3e5016e1b0802c54078f3cedee7c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c008795b09c79087de512c990273ac55640238a691158b282581503bea7d1fab"
    sha256 cellar: :any_skip_relocation, ventura:        "9c747aa7b40dfbc41104d987cab02a743e61455551c8786ae1f303bee9e58e80"
    sha256 cellar: :any_skip_relocation, monterey:       "08e31b1b2474bef1539144d4f7353aac4c16842e5ee0b350fd05a13a4e22455d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b09f623e77bffde0d01d7108aca68905dd354c20a3779ba7592709d3a4fbe58"
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
