class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.30401",
      revision: "314ca7a446f0d50a24a9b7afd6e9b416af45cc8f"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b897f67b0c8d4380f3bfe1a71cf1edd45449b0901b66ad1113ef7b6930181638"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2214ac4fec893714d447350a9082114cda1659f2f7b6353b430eed056582cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfae77c7db8ba47ea72ace6c572dbe2e252e64654747246a22223c9ef8581611"
    sha256 cellar: :any_skip_relocation, sonoma:         "c07107406cc943175d877ce4e177d8a160fcbb8f5837013226bbe67dca81b97f"
    sha256 cellar: :any_skip_relocation, ventura:        "4417c2bf85966f05eb95ded6bac1d01c4291a43711c70b23e8a6e22df461197f"
    sha256 cellar: :any_skip_relocation, monterey:       "b5afa41a599037acacf63b0a4f2a17c3bcce544c37be8d1d8945258620e31001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8daa6ab0fa89275bf7ac369849325aa516a27d6509458fd3e495f0503fafe25f"
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
