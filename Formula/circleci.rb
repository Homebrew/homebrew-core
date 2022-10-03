class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.21844",
      revision: "f124597e5e1845d216ae92dc8a3919b82b5eb043"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cdc343c0fd184f2eedd137351360ef600994c6dfdbff7d2c47fe8e4a2452b4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a2aecc777e979234ead86114f1390ad4bbd4054ef966795c0d4788defba7d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b52fe28b21a1115be2186f5e0f85464b6072f9fcd44939fb50db6deb2cf23ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "0131179e5bf273cc38fae5b48f11b5ca57531d1bdadb40df8792c413a3ceb297"
    sha256 cellar: :any_skip_relocation, catalina:       "742a3c934c8c759a1c8dc2d584a8583dcec7e57087435b06ced5780c90b0eecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd007c50102cbe869e43ee9906b1c6c57fad4936773c60cdc8509c56d0c131fc"
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
