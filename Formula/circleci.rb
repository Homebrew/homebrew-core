class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.24495",
      revision: "e901486770c2ad20f37b57c3809222216e88363e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a31fb9eb875302b4e6f1082af8fc7d78319f19c0de0cf36e93436c8ebe830601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a31fb9eb875302b4e6f1082af8fc7d78319f19c0de0cf36e93436c8ebe830601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31fb9eb875302b4e6f1082af8fc7d78319f19c0de0cf36e93436c8ebe830601"
    sha256 cellar: :any_skip_relocation, ventura:        "506341070653720e078c71220a9a97a004c015809502eb069d934933bb7e857d"
    sha256 cellar: :any_skip_relocation, monterey:       "506341070653720e078c71220a9a97a004c015809502eb069d934933bb7e857d"
    sha256 cellar: :any_skip_relocation, big_sur:        "506341070653720e078c71220a9a97a004c015809502eb069d934933bb7e857d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59c5b3fa1d2d1efd585711f82069336639fd8bd3839346287dc98f559d4e47c"
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
