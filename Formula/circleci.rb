class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.27054",
      revision: "68a3d97d39be29235867f926a683ab8601c48d09"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4272cf47c5ad2684a137e268b2a7e13146620eb5ef77df9f03068c0def15df02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4272cf47c5ad2684a137e268b2a7e13146620eb5ef77df9f03068c0def15df02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4272cf47c5ad2684a137e268b2a7e13146620eb5ef77df9f03068c0def15df02"
    sha256 cellar: :any_skip_relocation, ventura:        "78bc737e0a8437c9da2d7304379514e3d5be7d639fb612e90847058d79ab9a19"
    sha256 cellar: :any_skip_relocation, monterey:       "78bc737e0a8437c9da2d7304379514e3d5be7d639fb612e90847058d79ab9a19"
    sha256 cellar: :any_skip_relocation, big_sur:        "78bc737e0a8437c9da2d7304379514e3d5be7d639fb612e90847058d79ab9a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0649f01559f2cf023ed613a9a427b56ba552d47e66e48eb35174bc7637bce1ec"
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
