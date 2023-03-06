class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23845",
      revision: "f59d90e9055331c9f83ff0d1f5ed57dc79c91787"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0abd02a0dcf35beb261ea068b03a248e2e7222a90059c3930f338259a232af68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0abd02a0dcf35beb261ea068b03a248e2e7222a90059c3930f338259a232af68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0abd02a0dcf35beb261ea068b03a248e2e7222a90059c3930f338259a232af68"
    sha256 cellar: :any_skip_relocation, ventura:        "21a108185e49d702e9edf9a2ae8ecb67369169bb4a82bbb7a29f7025d539d807"
    sha256 cellar: :any_skip_relocation, monterey:       "21a108185e49d702e9edf9a2ae8ecb67369169bb4a82bbb7a29f7025d539d807"
    sha256 cellar: :any_skip_relocation, big_sur:        "21a108185e49d702e9edf9a2ae8ecb67369169bb4a82bbb7a29f7025d539d807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c11b83005958e32d51e04a396fa1d38bf6180e53f2f5e8cc27fb03ccc4ca31"
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
