class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21289",
      revision: "3b49940db83d496241211861c4d3e209d48f1afb"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547bbccb718b8b42ea9608131237cc7ccc7f3d3d4ebe1e6b0a2916e89ac987d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1c84d5215fd9ea9d0e57538c100ae5140598df214357e5ea3eacbc80163c3e2"
    sha256 cellar: :any_skip_relocation, monterey:       "eca96141f625f6697d0f206ef3cd1204eed71f99bf9a7c2fad035b62bd7096b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dc6154875732c61d2c4580472560078ece81903031cd470c06e01cbc353501b"
    sha256 cellar: :any_skip_relocation, catalina:       "82885ead465b565f4c872d5e9da172c6042ceea5e7aa26204f72e08da9b0751d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ee2c4b309d2b783c91908cbb47fb96684f1b73307ac8f37c8b38e955f4497a"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
