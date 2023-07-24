class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.27660",
      revision: "35d39ea8497794057500d8ad2deafccf547343cc"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdecb551a06bf198599ac6c5476c476726a5f602dd78382144a11665f3ffa37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdecb551a06bf198599ac6c5476c476726a5f602dd78382144a11665f3ffa37f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdecb551a06bf198599ac6c5476c476726a5f602dd78382144a11665f3ffa37f"
    sha256 cellar: :any_skip_relocation, ventura:        "d72968617869b58dee2f8713177f36bb9902a8236478c94d95ab32eeae0203eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d72968617869b58dee2f8713177f36bb9902a8236478c94d95ab32eeae0203eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d72968617869b58dee2f8713177f36bb9902a8236478c94d95ab32eeae0203eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46127c16b7cbd4ee9464fe8cca4d07b90d95659edd62548476c288d04115bddc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=homebrew
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
