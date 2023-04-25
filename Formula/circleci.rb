class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26094",
      revision: "6f8e97e2ac443abf05f72203bc279a118ff9aabe"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d3a1c10f0241e12f132273a9409332d8b793f6e55d4f066099ed2ed2361741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6d3a1c10f0241e12f132273a9409332d8b793f6e55d4f066099ed2ed2361741"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d3a1c10f0241e12f132273a9409332d8b793f6e55d4f066099ed2ed2361741"
    sha256 cellar: :any_skip_relocation, ventura:        "b915d5e9a1460028cd496bd6c8311faae5e769fc11642c8d3ea6efdb0602e273"
    sha256 cellar: :any_skip_relocation, monterey:       "b915d5e9a1460028cd496bd6c8311faae5e769fc11642c8d3ea6efdb0602e273"
    sha256 cellar: :any_skip_relocation, big_sur:        "b915d5e9a1460028cd496bd6c8311faae5e769fc11642c8d3ea6efdb0602e273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa443538684be2b48008833b714b93b665d407460571e53791f3b92c06097596"
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
