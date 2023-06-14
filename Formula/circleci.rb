class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26896",
      revision: "2b4f80b58ab8f2107377134473e87affcf98ef3c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a969af4dd110fcc4106ad9febce04336c41790b5b2f85cd96ca4d336b99f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6a969af4dd110fcc4106ad9febce04336c41790b5b2f85cd96ca4d336b99f7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a969af4dd110fcc4106ad9febce04336c41790b5b2f85cd96ca4d336b99f7e"
    sha256 cellar: :any_skip_relocation, ventura:        "dafc842bb534c5d6e79eb7ed99131883b07789faa3f18d42e9a3db3c721362bd"
    sha256 cellar: :any_skip_relocation, monterey:       "dafc842bb534c5d6e79eb7ed99131883b07789faa3f18d42e9a3db3c721362bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dafc842bb534c5d6e79eb7ed99131883b07789faa3f18d42e9a3db3c721362bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161714f736800205e68578cf51e6612c03eb0bcd76872bca8c84b7994db83e0d"
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
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
