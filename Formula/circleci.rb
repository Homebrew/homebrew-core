class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22924",
      revision: "a272a9fc86292902be6ed2b59374eb768dea32ac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76488b9719d50ee6dc8497cebd58cfc550196d391d257dcce9a84b04648bc25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dfff8e228163a474da3281bd769d1cd7ed84c3ad71dd0a00c71cc792d71499e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f921f9384d00b120b8f0ff20b58ef505408b9f0c2ad4d7b325ba96421ad62b7"
    sha256 cellar: :any_skip_relocation, ventura:        "fd09238d672b0fa462b262a72e006e48845d6f52eddeb978df2c491609616336"
    sha256 cellar: :any_skip_relocation, monterey:       "04711925d76102a1938d9c4c42e88311ced2d122bf8cc66fbeb824f3d2dcafca"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bad2839db56213786030681c9fdc711355a184fa51c2c0f0ba017104466fcb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47972365a3b08789f56115c6a6c12853f61c421686a2807957d5eebb0abf16c9"
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
