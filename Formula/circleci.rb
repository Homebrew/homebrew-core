class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.19541",
      revision: "f3c17207b51e455c0c001ca9e7aca02d9d8a4216"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c00b27fe2be2510ac43644641f9094785ebded1ec78459e99e1c347a0c2b3d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a71e824428d2fc2d0591e9e0fe0057434258b436a4caf93a4a49919177d58479"
    sha256 cellar: :any_skip_relocation, monterey:       "38d089c5e2460d599b4f632fddef4b0f4a93d29ab6fd922fd93e6602996cd174"
    sha256 cellar: :any_skip_relocation, big_sur:        "78274db9e20fd6c2bfebfb545dda5f40c9025c716b859ebafe78b6caf5e5304b"
    sha256 cellar: :any_skip_relocation, catalina:       "475b3706c7e5b58242fedb5f43d7500acc71231f09b25aa73979d0e77f505d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc0cd8876ce650ade2fab0dd662269e0a9c40bce36ee7633eed5eb678578c81"
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
