class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21041",
      revision: "56e791be647558532901ce7c566bcdf47964daed"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce173dbc2ee334b4348477616b1242e2d0d63105229d901abe1d7ab40d3fb679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "292e7454b4e9aa82fe1f1d571c837514a9cd10921d663868aefb6b008fbee4ed"
    sha256 cellar: :any_skip_relocation, monterey:       "265ba252f3be7a76095836bdc7fbe4c71605a4241894d60adadfc67bb8fbcd8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f1f4f8b807b3a836535b4b0d88797ff91cfce280f72e41022b10320422d857"
    sha256 cellar: :any_skip_relocation, catalina:       "ef25c84b7e8a17cffc23b2e9b2ee327e97c0d5cbbcf5fad2e0b0e8f36ef6c40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e51198ecb97394fbdeee99b83b63abba4edb64abc6c7dde101e94c5229465b"
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
    assert_match "update      This command is unavailable on your platform", shell_output("#{bin}/circleci help")
    assert_match "`update` is not available because this tool was installed using `homebrew`.",
      shell_output("#{bin}/circleci update")
  end
end
