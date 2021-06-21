class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15384",
      revision: "149d854253b354a7f6d7497f6f41451efb5aa5a9"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46c107700e8fd2e46ab04c98b02c345a3f4d2c7438d5e65c517410bc6a68098e"
    sha256 cellar: :any_skip_relocation, big_sur:       "cdb41db7e4427bbbb8bd0d308de6930cde264d5ec7c68cf341d82af803237b3c"
    sha256 cellar: :any_skip_relocation, catalina:      "a028274a3b7eba6ed036835f9e0f8cc6a9900adfddb190953919444b246de36d"
    sha256 cellar: :any_skip_relocation, mojave:        "c752bf21ecb6b2fad282af6055b8f23d5fe4db71c4a2effb7324029e94d92c86"
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
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
