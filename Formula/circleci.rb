class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.25725",
      revision: "63309c6632990862b573d4ef42602b12e9e24e77"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a537280238a3f768be536b76df7ea2669be8295d58bfed5262ab32bfdd1606c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a537280238a3f768be536b76df7ea2669be8295d58bfed5262ab32bfdd1606c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a537280238a3f768be536b76df7ea2669be8295d58bfed5262ab32bfdd1606c3"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b32dc06bfd978c542f7e657fb65b55317e986252c87d1382256c5cb7e3a297"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b32dc06bfd978c542f7e657fb65b55317e986252c87d1382256c5cb7e3a297"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8b32dc06bfd978c542f7e657fb65b55317e986252c87d1382256c5cb7e3a297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5e4cca9132ef82102c3524fe2e567cc0aa143b1b9d42ebcdd4a7b3ede8bec1"
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
