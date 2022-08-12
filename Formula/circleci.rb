class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20500",
      revision: "e042377324976cf0cf63b2b930369ac5b1ea634b"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f0e1841a403fdd048cd5f91d397adb42485630c43ff0a8cb0e6c5994370de3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91a0e3f8e679b29f1a36bd306576d1096f67477b913b04cb3d01aad3eebc74bd"
    sha256 cellar: :any_skip_relocation, monterey:       "4d95beb2510b5ac95ad7e600de35de1ccd998fce4ac2405eceefb4d591c0d9f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea65bfc744271e78625a14e0d2f35c2689920037c7c0a475b81767a158f0a02"
    sha256 cellar: :any_skip_relocation, catalina:       "5553efa9a9c749b7a39b4ddc37bd623fa15dea66db166195fe2054d2a36a31a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28f72c985258ebbbcd7fd8efee1b55ae98cbe70c2e22c5940d313cc49447409"
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
