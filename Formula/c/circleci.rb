class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.30549",
      revision: "735ecd3c6f2f707563e5884ad54f9b000e60f28d"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aa85a67d1e6a61108ba5ea8b217211a33c50aab26418471b37edcaab01dafe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183aaaca45d2091331e44d657f56a6416ab85d79ced07fb63aa9209c457b3128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "269b767c65fc9b5c2aa899febfabff045f5c402153867d0f44e833c01a104852"
    sha256 cellar: :any_skip_relocation, sonoma:         "6582633e1f187211461d4cbb3b16eac13c9ec56cb76ab9037115a2b4a89b9271"
    sha256 cellar: :any_skip_relocation, ventura:        "9f49bf5f36ba61ba131f1086dd41d7282d5762909ac7dad88e7898209512a4ff"
    sha256 cellar: :any_skip_relocation, monterey:       "636520ea01dc34105f1e2c0b600f6eba9441c57f0fdce7570d09cf12126eb4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7ef79400af3fe09564b208e23e7fc796f7ed2e0907a692dd57a3a6e714ce8b"
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
    system "go", "build", *std_go_args(ldflags:)

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
