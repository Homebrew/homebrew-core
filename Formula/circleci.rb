class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23272",
      revision: "b56f979bba9679e11bbefab4218c25272b66c913"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72853c0c9be4024c39faa831f340d4ff34e3e3561437fd817a83628857c5ad01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27318b162c76c76bd9ffc7c8e7c1cdd0dd08e3f64b849f498742fc0c2ed4e301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b607c5bc72d201eee9fa5e1b80d681fe4be4e7ee6d80f12cda90912e1e87bdc0"
    sha256 cellar: :any_skip_relocation, ventura:        "f76833f14d1fdba33e6d784ff4195012b2d46895fbfce4612d8b99226d161471"
    sha256 cellar: :any_skip_relocation, monterey:       "451062b58ca1c6fe887d290fdb1de552daf3209c9ae91a7ede3643ab25009e91"
    sha256 cellar: :any_skip_relocation, big_sur:        "f99f21a953af4fd6d28c250c63075355f15cbcec77f437232624286b9726311c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b850b9e6a338e48d1a8cdffc3473342b713c97229cc722fe526f026cc3ca634d"
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
