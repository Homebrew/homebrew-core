class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50831",
      revision: "d6b7cdf51ba4683a102e485c93d3e6e64c821b54"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ee70a581f0f527ff491674e6a799364b0c3eda6fcac3f720d9e303a149ea1ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37820c8f86985596033f1c4bfe029d155c51d95aea7d89784b338c641fcc5cee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53f76a3ff79afdf75f387729f9878c49efc189fd5e967aadc68b0ecf0500ca5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef17b4e0dbdcb3c10a3d53da60599df2cca88e05294a02681770cc6175dd5747"
    sha256 cellar: :any,                 x86_64_linux:      "bdc85be790dcfa9960f0e4da82b6a8a8aa5edf3d88929ad9e25ca067e23875ae"
  end

  depends_on "go" => :build

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
