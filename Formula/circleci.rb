class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.15848",
      revision: "da3388b703500bb515aa29e67cce853ba5a5a111"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "923ce12d1bcf89d01620c440036ca17578ace6c286654b465eeef8a7c733eb62"
    sha256 cellar: :any_skip_relocation, big_sur:       "91b1157e099621d97dbaa290ebac5feec771549bd2cf80ac13ac1a032735429f"
    sha256 cellar: :any_skip_relocation, catalina:      "db64503dd7d02677a873e64dae028bfac1a77e13edb498cc59a487eabf3a9f62"
    sha256 cellar: :any_skip_relocation, mojave:        "386e4fa8424afd48fd985cb6825a0f93ec213d202c49f43e804f1c2fce38c2ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69bbf3e8c3a3003c7fd9c1bb1782eb0eefc00faf0b3986feabd08fe8f1e97165"
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
