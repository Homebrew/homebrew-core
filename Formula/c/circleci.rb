class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.18.0",
      revision: "de81f172cab71681440d72f2b9075209e4c1641e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f54b28f13ca20f4d8f9002f1d9d120f7d237fa6414d1d86760b064a879a8d4b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d960ae81fca543aa1e732bbaeec93b9c9eac0943cbde3cae9ddef1f5f4cb12e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "963fc85f3063129a70d97745747be4d9e0accf9b489fcded6adcf2e2201aabd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c206ce9b6413f210146e23e6ef50f193922490c786c1dd4384f3589a425263b3"
    sha256 cellar: :any,                 x86_64_linux:      "2571519b0a51ef983a1ede4c7adb5645095db56af3416f74e86a5f1946216147"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
