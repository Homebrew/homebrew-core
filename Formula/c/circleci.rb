class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.20.0",
      revision: "e596bf276e034ee7b1ea7ee8c5ec07763381e45e"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e487c3db4e18c1b3a399bb745f5e2f9d588ce0e35d2298381ff7447fc205f07e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9df4ac178c5c20176d9cb0e292d8ec07f6f7c066909cc1354596c341ebc78a8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "426c039e522395a84e7bfe0535b4e0c5e73b38c252c763367287d95fc2d8f3ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74c676d0427d2fe004ba6a0f9e56eddf0466ffb1e7388c5d1d6eb72b7ed9a48e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "021a229b7863a7e80ab293441efb8388d9a4474ddb23cd5444613e43e139599e"
    sha256 cellar: :any,                 x86_64_linux:      "7ab5ccf033fc54e61b7cb7876719726897ac29598fcfb900ddb21abeea33cf9e"
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
