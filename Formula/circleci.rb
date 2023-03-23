class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25007",
      revision: "8abc86a1a8941f69891431ec58949c1befc53eb7"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90bd1ad1ec7ce46f52f869c2409507329b015a27a17185c247b1cad1debed42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90bd1ad1ec7ce46f52f869c2409507329b015a27a17185c247b1cad1debed42c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90bd1ad1ec7ce46f52f869c2409507329b015a27a17185c247b1cad1debed42c"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4384e1da8a90ab2ffc8c7f1a3d4fe70e03bf2aa28aa2201310db8a10c68905"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4384e1da8a90ab2ffc8c7f1a3d4fe70e03bf2aa28aa2201310db8a10c68905"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc4384e1da8a90ab2ffc8c7f1a3d4fe70e03bf2aa28aa2201310db8a10c68905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484a58c8b0070a0f2a41ef902a76bfa0612e5869ded89dec1921f7aea4526aba"
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
