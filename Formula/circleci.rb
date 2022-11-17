class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.22426",
      revision: "7cd9cc4df4679b2527daff299ae38f623e11750e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc1742080a066d682062de183e7499d1cfc806a417ca841716cc74a0b20c5c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b05742b5c284592055bd0a90d88a5974dbf7a2e5563b73891cf37a61aae9c04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73a6b9ff2a2deaf601068a681e7c39c83ebdc065a0256f46711797f48b264ac9"
    sha256 cellar: :any_skip_relocation, ventura:        "2b851bbdf3d4e8d1e60762bde3bef0a57fa8c9757f88efc1096492b80383aa1c"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9482cfa384bcc5c0fa55b0391fbb95f583f4d0ad600a40b99c772de34adbff"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4351ec7a8d41b08af7ec6237ed17f2a672bda225d273798ade98e155271f9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "0c92c077a6fc0bc80eb1e89e490b34a29d096cab13cf4a3f8f5e31ad116053ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de14e6ec81e1eb24afc5889838c3e1b93e8c5c3a35a6dd968e75cde8d0194489"
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
