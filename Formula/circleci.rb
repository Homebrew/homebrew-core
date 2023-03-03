class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23816",
      revision: "0ad35cd3f13fb21bdf70de11442e03cb3858ab69"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466f4f8895a68d6784bc765d3ebf5b9d082187c64e91f245d7eefe411496f082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466f4f8895a68d6784bc765d3ebf5b9d082187c64e91f245d7eefe411496f082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "466f4f8895a68d6784bc765d3ebf5b9d082187c64e91f245d7eefe411496f082"
    sha256 cellar: :any_skip_relocation, ventura:        "604b6ecebe87683b6a3733bf2a3be6f8a1cc5846b7f474d6045c34ff216b480f"
    sha256 cellar: :any_skip_relocation, monterey:       "604b6ecebe87683b6a3733bf2a3be6f8a1cc5846b7f474d6045c34ff216b480f"
    sha256 cellar: :any_skip_relocation, big_sur:        "604b6ecebe87683b6a3733bf2a3be6f8a1cc5846b7f474d6045c34ff216b480f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a9b057235d24aba5c310d7af37d375e9c6fe6f24613e4f65466969925ade2f"
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
