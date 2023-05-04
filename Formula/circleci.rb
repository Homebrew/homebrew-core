class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26343",
      revision: "7b38e08838b5b8cba8ec4208b3bd0149f1f51777"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1745cf9792a998de71560f8f4d9d62731b54569dc5f02615febdbaddcf3be584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1745cf9792a998de71560f8f4d9d62731b54569dc5f02615febdbaddcf3be584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1745cf9792a998de71560f8f4d9d62731b54569dc5f02615febdbaddcf3be584"
    sha256 cellar: :any_skip_relocation, ventura:        "dd8aa58b1b8b084bbd0a5106b6939b02d21f0c66e07f583119c64d9f2a1bbebd"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8aa58b1b8b084bbd0a5106b6939b02d21f0c66e07f583119c64d9f2a1bbebd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd8aa58b1b8b084bbd0a5106b6939b02d21f0c66e07f583119c64d9f2a1bbebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19279dcc9c787619f12ef8b5a3234b1ab5e97bf0a647bb05669376f03ce6150"
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
