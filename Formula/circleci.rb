class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15606",
      revision: "1ebdd3f5f2ad320c40dceccf8121f128247999eb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ac9dd1593919cb7ec94913692eb43c90167c5430cf4f5eaaf7253db156f7253"
    sha256 cellar: :any_skip_relocation, big_sur:       "70db6bff4b012cbc42b9899221a11259b3f25538dec336f95302ea20f5761437"
    sha256 cellar: :any_skip_relocation, catalina:      "b958a7688c02c083b8f2c7e18b933a790063611fa05bdda00e8bda10301c93b5"
    sha256 cellar: :any_skip_relocation, mojave:        "cbc6ecc841ed1f2fd53157d22358c1f3cedc6f319c95f123ac9cf4328e03d928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0436fb133df5c66ee8131bc4f1c505e1b354540632d67c35a49c587e6fe3c4"
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
