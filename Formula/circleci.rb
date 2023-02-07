class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23391",
      revision: "5cbf90e58053271341e25c0142b044a77a96271f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c25bcd317965c8acc7d00790769c5cb687788e262d8056bc56804f2e4b7075"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c7fbe5598f8b27d7f186f88d6c3a6065f0749d703e85089e8187c90d238450"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d40dcb481f1f6f40994604cce0e771f82711c9c3f950353d6c4eed7a64f1fff"
    sha256 cellar: :any_skip_relocation, ventura:        "2bb8b271e5ad8859b3aff2eec8b2da07fb23f3a9a4c5f8d8a720d1278e092496"
    sha256 cellar: :any_skip_relocation, monterey:       "d151e4db8eba268bfb0df869dc4e75c42a6b0e7e5af90e7dd5430ec643c1ae24"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfe8273fa5c6cf489aef5ff6b2188c77db8de29e975d27f58731fdc98123c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129c83ccbcdac3d6f61952970adb2f74d479c0b6e092ffc678c9ecbffb550eb7"
  end

  depends_on "go" => :build

  def install
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
