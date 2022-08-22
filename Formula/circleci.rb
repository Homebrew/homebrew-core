class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.20688",
      revision: "168582f34e3efa133c0eab7bd51df2b6c1857c6f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9a2a2359eb98bd1a1b559af284e5e68dcd393618fb854ed3d503351a39ae9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73a23d3b4c36e367742bc5a7e3a469512a03322c9139c74436b936f593a4d62e"
    sha256 cellar: :any_skip_relocation, monterey:       "4083395e7516a37a9634d3923675713464693296c68d7856571a143b438eecbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "74a3498fc27e65e852681fd98b2895f4c8f324271a32249353c1e65bb046a80f"
    sha256 cellar: :any_skip_relocation, catalina:       "14c94e4eec1f1e0a7ee867bda3344b3ac44da0549a0af40a193e0da030d785c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166759d04d6f13968e77437fa4ec5caa0581fa35249335ce27ead8b895a2873e"
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
