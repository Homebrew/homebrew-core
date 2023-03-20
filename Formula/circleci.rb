class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.24435",
      revision: "3b4aa7e7573dd90002bbe2371cca1ac3c8009471"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25cb4acf7695cec10d02cc446bb08df674cb2ca59410ac4341f937ae609e1de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25cb4acf7695cec10d02cc446bb08df674cb2ca59410ac4341f937ae609e1de0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25cb4acf7695cec10d02cc446bb08df674cb2ca59410ac4341f937ae609e1de0"
    sha256 cellar: :any_skip_relocation, ventura:        "81050b2af7585a855438c3c94944da258d8e60c3622182814fee046fcb483855"
    sha256 cellar: :any_skip_relocation, monterey:       "81050b2af7585a855438c3c94944da258d8e60c3622182814fee046fcb483855"
    sha256 cellar: :any_skip_relocation, big_sur:        "81050b2af7585a855438c3c94944da258d8e60c3622182814fee046fcb483855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf05fb00ec4aa5e6f377f0d26799f3a5b1a0fef8e7e22c627884f905b042724a"
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
