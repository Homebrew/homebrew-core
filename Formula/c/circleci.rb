class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/2.0/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.32638",
      revision: "2bfc35c9de336e78ca2bc1f806edad775e0b64ee"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6711a94c7279f9754062a29ae277d58ea7c8067c79b01ce95455b9c7f780c2c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "884724b08b618078c0422d1640df0780a6f3c700c9f9668155ce2f822395cc77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8a3dcf024d48b4850eb73c204fa47bb8b977702d37e31daea06b37d2d76642e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf46924162c910e51974d5f4d0b45f64ec755a05cfc9e2dad56f555e762ac8f"
    sha256 cellar: :any_skip_relocation, ventura:       "ea035bba7e0291803f458d0d33923c37ca05456e6e2f35cccc6cf67d622167c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4deb89f8933f9ca569fb11f454f818be0cc8c3796b888fc2f410cc36ebaceb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
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
