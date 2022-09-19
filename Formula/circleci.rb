class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21194",
      revision: "0f1ff57542b90c399b7e5675c16f1bd1a09d970c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c88b3edd5c17a505adf43b93fde4d06cfc576ac0c6c8c4bcfe41e317b877567f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f232eabfa564c9338d0098258899d4ff9482df7194a24bd1e5091261f6c8bbc6"
    sha256 cellar: :any_skip_relocation, monterey:       "7f069904f4aa52c40893b8697a00a7b1050eb9dc2e0a671f4a780fd4fd24fd6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "038e97772f107d4eb68c6f95927b2f03eb6ee3fb9660f513b15484ccaafdde50"
    sha256 cellar: :any_skip_relocation, catalina:       "bd626de91ad8db17ba5a038a956d8451aa631cfffd562331f6c01214a5f81f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8becf1f44d4c169deea08507cfa93209eba46e53fd703994c0a9e0aab4c32d33"
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
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
