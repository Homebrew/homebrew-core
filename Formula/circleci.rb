class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.17497",
      revision: "77066e803c166cbad4634eccfd3626eed8ed2eac"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb839114ec1781b60ffcf945ff889e8ec926b5b3ed420edd064a1e376076125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33722b3f21f47a2b393b15e06488eb0ca3bb10cff8c6d210e7364793a2e02fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0dc95c85886a85e979bc471ff83b0842fb81701f95246b608b36cdfb70f840"
    sha256 cellar: :any_skip_relocation, big_sur:        "28d5430df01b8bcfbfb22bd438042419b3e5573bfabf63f85bc065abbbe8c9a8"
    sha256 cellar: :any_skip_relocation, catalina:       "ab632b329f786a167127cdfdea38992bd8d679f18e69b547e4b731de4fdd2eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260513a1f382cf7f6bbefec39a851502d022842a4a106caa91f843ea58ec5592"
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
