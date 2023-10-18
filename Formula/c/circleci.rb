class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.29041",
      revision: "68d2c2029f3aff4a45e37fae21a55e092f355f66"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0309077706bb41e649b95f6fe5e2e85519f182b3c943137a35f6da721a0edea9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f755733e3fe7bccd0aef7474bd52e0b3fa384e696cb7036dfdad48d8ba5622"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dedd715a7b301749fad3773880f3e97fadd200880e178dbf7c0f0f363ab238c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fc2b09802fbe1751d9d418ae19bfe367315d8adbee89581532e29a30f823643"
    sha256 cellar: :any_skip_relocation, sonoma:         "9418e6a62128aab97dc7c4c7d2ea84def8e54f95ce251fc8130e44f4e418089c"
    sha256 cellar: :any_skip_relocation, ventura:        "82ecae9486302ae472821367877a88172ed78f851fb1771c678eef54571ccc10"
    sha256 cellar: :any_skip_relocation, monterey:       "f091952e54a1289f7d7b7e7731373ec66bb00710ae1536dac06f3d7bbc5a060a"
    sha256 cellar: :any_skip_relocation, big_sur:        "457a44f5d98254328c206a5d60392aa8c3594de97cadcedaad9df099413be06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb95421aeeff98acad1678a9954a61bb3bbca3118b05630e9ac3ad50851c0692"
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
