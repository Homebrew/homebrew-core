class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.18532",
      revision: "5e6ca987d44c4901fece26415a933d17ce950ead"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e015e481e09ca4728a46e5ad4ebd2e698a8036b45cd5140e77ebe84121cbca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cc0ad554a422f00ad024470062d9eca0468568b4fe266d3fb2a47f6f7cf4e66"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b0f354239da7e6ef72bca0f6a90cd9868a9a400e464ce51b628b96d6cf8161"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c635769a1d40686fa57700f028c61b8692eb916496a49e00d438ac3b335448f"
    sha256 cellar: :any_skip_relocation, catalina:       "651f2293275bc0445b6346c201710f2a0001ad1ecbefdc9564ec05a5c4505c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "397877e963c86b2ce3b63330d58c4e787e73c8158bd6cb7cbf7e73edb8a2d1f2"
  end

  # Bump to 1.18 when the x/sys dependency is updated upstream.
  depends_on "go@1.17" => :build
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

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "bash")
    (bash_completion/"circleck").write output

    output = Utils.safe_popen_read("#{bin}/circleci", "--skip-update-check", "completion", "zsh")
    (zsh_completion/"_circleci").write output
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
