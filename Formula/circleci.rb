class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22322",
      revision: "5ff92b4ddd64da789d351c1a070ef48340a23b41"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a6ae4824ebbffd5b5dbecfb42077ca90427c195c220e5a2109d971b2beff970"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f756e09dd69003027ed06346fb19c367de7e804422ef64f3043de04a90f2140b"
    sha256 cellar: :any_skip_relocation, monterey:       "105c4081a981ab0e36f2dd5e873dd6e57ebe4d11b3cbffe8d121bd629be6d713"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa941ff2d47847eb0f3e97b04fd6c7247f3781a70f8939d037e9cd6cb83b36ef"
    sha256 cellar: :any_skip_relocation, catalina:       "528bec32217c7bb81e406d8370f4cec913abee194367b995f6c8e35433c97736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff7a8227fb8bb0d3f6bc639edc499773e6cf445e6bb48d6cff33308b2b6d34d"
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
