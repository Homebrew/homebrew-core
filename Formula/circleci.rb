class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23667",
      revision: "72f4cb1bf641803fbc4ec25d8789520ea135e0f4"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba7b9301de3e59da9bc6f8b566efad8a29391d2d901f3e4a7f620583025a63be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c575d6c10256e464e897f6b02627ad96e25636f6439a8c78e3283aee1152fae0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab9b71801bfcd16da33cf6889eba138866e3b3fc31a9e99afe5d1f9ac25d39b5"
    sha256 cellar: :any_skip_relocation, ventura:        "30fe91bb992e08370e1fbec6b49f784ad8110ae8733f8d9237a57900ef3a4aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "707d1abeb7d420730b146df6ba67cb755849160d7e5bdc524abe6da47c38a82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f535eeac00a2e256c3e32719f8ab8f85c595407c21aec5108be3e0db5c2f0cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200c7addc6458bdaf65f9628c7953a8ac5d11d2ee1b682fa5ec8f2d490113b60"
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
