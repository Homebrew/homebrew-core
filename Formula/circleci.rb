class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19470",
      revision: "19748d2aea91850ec89b10845e5381c104eee101"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1cb21ed979afe8b55df06117ee66a7bf6920d15c141d20ecde415a51c378b83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae7e4f8a32e1c8fee00315284c3ee4c96a26cc9375b5f24f613e0a8e523be26"
    sha256 cellar: :any_skip_relocation, monterey:       "f3c1ee91c5d9d8006e6c0d662487da75799943930ea86192fdf56a205e39082e"
    sha256 cellar: :any_skip_relocation, big_sur:        "be65fd9c542cbfe8803e1424e18964aa732813edc2b1c40e7f0b423ac4587ff3"
    sha256 cellar: :any_skip_relocation, catalina:       "a7ba06a27f801ee7b6e965ff679aca41ecb5892563b485ab83e02c0e8cfd6a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2259dd3070ba6dfd922318ab5307c2f2a292911e06fd8d4fe4f26917bbcb36c2"
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
