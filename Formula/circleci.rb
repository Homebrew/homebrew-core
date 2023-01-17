class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23117",
      revision: "99feff36ca9eca7348f7a5e3074d3004cbbc5136"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8276af8f97a9be214311e0b67043f7a4c4ea2037e45591466df06c59924fd967"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe95722db2bb0a04f5194d77d59ed5792df12e8a2dd33bed25bf8f812b47e3db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f054778002f67066558dd010d53de4cd727db798eeaf5a8bea225ae9d9330fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "79aa2960567b13346ef5cfd0acb0362737124589fe9744ceca9df260b374b58b"
    sha256 cellar: :any_skip_relocation, monterey:       "e2c48f87813e37879ed0557beee0b6d579c085105909093265cb42fe167cdaa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b4bd7eeb91d97ea8777c42e50a2a36628fbe8a1fff4d8d9e030db7db06fc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230b931f813a1b5d21b0a9820923cc4bad060232e97fed97860a9877f211bbc1"
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
