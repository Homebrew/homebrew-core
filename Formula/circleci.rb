class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.24705",
      revision: "8efec6dd2aeb5600e8eb608fd2927ae966cdbfa6"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c1a3bc2512a2433b510f1a915aa468b69ece485c95d23b82611d6247b18b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c1a3bc2512a2433b510f1a915aa468b69ece485c95d23b82611d6247b18b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c1a3bc2512a2433b510f1a915aa468b69ece485c95d23b82611d6247b18b2b"
    sha256 cellar: :any_skip_relocation, ventura:        "a56817c3e22682ec0ce3956139c0cf21fc1ca65bb403fa6869c571145debd6c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a56817c3e22682ec0ce3956139c0cf21fc1ca65bb403fa6869c571145debd6c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a56817c3e22682ec0ce3956139c0cf21fc1ca65bb403fa6869c571145debd6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46dfbb5b206f0edc5443fd10b361351cff81f31af4bfa873a39f9f6984323dc5"
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
