class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.16277",
      revision: "0aee802464471fcd2d06b18b9a501da241afdf72"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b037063611558291f4419adee723ce4c73342819253ff3296bcb14e804257c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a50b16ee9f2be661f27886b2394bc0bf9d5a297baa1b012229e8cf410792d0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca0aec5d90ea8c121e29b1a2a97ae2194d58c41a9d596ec56a4b9cd6e66e661"
    sha256 cellar: :any_skip_relocation, big_sur:        "da1f7b00279b4bdf672097a45d0ac5f7f0341962c8c3f59a3ea1dd47b6f4444a"
    sha256 cellar: :any_skip_relocation, catalina:       "cf55fa5a04a261f96cc8c78ae6d618ad32e4ed27792436db3826648b6b13aa3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de06fea264b40114d8b614e0fe9340349961d04d980699c585925a603a16f734"
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
