class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22272",
      revision: "cbf9fecb0c8232c997ff959998b359ec60a0c746"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b80e986eff594f16f011236b3d1bf97407a0122ae1ab798ffacd0440fcfde34d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ff08211a92e9492f525e75541007d9fb3fbe8c583e0ee97b6a5700e5a5159db"
    sha256 cellar: :any_skip_relocation, monterey:       "3e2c7d18e86ddfda3f82fe060256f8a49da0d98f91c17b5ca1e594dcf92f7229"
    sha256 cellar: :any_skip_relocation, big_sur:        "96cc2f2a43b3378f474e91e3eff35971aa593d39c9dfd3f89c4ba5a9b8c6df14"
    sha256 cellar: :any_skip_relocation, catalina:       "707660979de55f6c03e929dd733bbca45feaba3bff6558ce88c683749dc88e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd69124af7194cf6f2b723639edd2e798ee2544b3eaa3588ddbe8cd60f4f50a4"
  end

  depends_on "go" => :build
  depends_on "packr" => :build

  def install
    system "packr2", "--ignore-imports", "-v"

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
