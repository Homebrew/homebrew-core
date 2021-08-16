class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15824",
      revision: "effcb62fd73da19505931e9e29f77a734eaa60da"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a7e0a5e77aa7e9b2112b474d09ad64c74134c7267c42251fdde742cbe0e4ae4"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c90da05235df028630c8421b7a5a1e99505ba6f4169eee21c7e35134184bc64"
    sha256 cellar: :any_skip_relocation, catalina:      "c581c81c344f51f542ea1ae0df4abcc3d9a8448b92ee18d8818d97de6c8d915a"
    sha256 cellar: :any_skip_relocation, mojave:        "f70ee8de98d83c365c8f22a3e9ad44b73248b1e465759e03b64c82fbe41fa47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b50280724e6d95abb609808289bd07bbd253d051cf8d5c268ad1618915211e7"
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
