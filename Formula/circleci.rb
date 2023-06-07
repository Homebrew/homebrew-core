class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.26837",
      revision: "b104265186724fffe9d6dde6706a0cfa245e5778"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfcf290e0c46eeea46e875de1d3013db7165fd61f79a6dde3af747dee386e628"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfcf290e0c46eeea46e875de1d3013db7165fd61f79a6dde3af747dee386e628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfcf290e0c46eeea46e875de1d3013db7165fd61f79a6dde3af747dee386e628"
    sha256 cellar: :any_skip_relocation, ventura:        "27274b1160341639dcb872618027e50f7b22805e076a3008bb50b85328cc3001"
    sha256 cellar: :any_skip_relocation, monterey:       "27274b1160341639dcb872618027e50f7b22805e076a3008bb50b85328cc3001"
    sha256 cellar: :any_skip_relocation, big_sur:        "27274b1160341639dcb872618027e50f7b22805e076a3008bb50b85328cc3001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406ff0d6711aa8b8e64e264ace677eab2cbf948abbde339cf62aea7b97839c0a"
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
