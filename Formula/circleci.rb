class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.23584",
      revision: "634103aef52c3f6360207a7e63ae419ac1b1baec"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c29682564ca12b58e40a77a3ac5daabec899168d33dfe17a7b908631018972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f340edbae5634474a4e35e8e29d371eed1e60e09cb5672ed8bb4ed42f7f7b89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c7c7a2e59501273d95980c900ee8cc3e4aa92333a6392ba7dd917690cca15d3"
    sha256 cellar: :any_skip_relocation, ventura:        "6aea1120ed8b02dda9e95f9dc09d7a7fb8256994d4ecf2e2cc094e751c937f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c8ad4d1c515e5a20f6d866e878c8deb6de77d2569e6b031371fd9d6b77faadb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2f49aff20f14d9893fa83d1877b64ce1325136098ec4bff8bc716ee79019cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fd8c6cbcc288d10a4f553a816d12415b85fbc11ed7175bfc98f55be8e135437"
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
