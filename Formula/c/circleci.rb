class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.47928",
      revision: "cf232026b9f3cb3308e901bf4fa4cfc93c3f2a59"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "718c58b244d3c1b2cf1a25151dcab76beb65ff07d33bb9db67dee0f21e73fd6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bbb9d885682c2de104c141a5b8e799c14d1dd39e350c840d927c6a9e60dc4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c238f984574076bec8ccea0a28a92dbfe31fe3812428f20b6fc3a4c94de9ce2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf55edb672d74f7413cbc13bf067be6956714a30536a9c71cae6e06a090f58d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2951674cc2afdcb60ab3b7ca8f6af0beb3486eccd7a66ee2714dd92392edba5d"
    sha256 cellar: :any,                 x86_64_linux:  "35f48119f362bf3897f081bf94e492d68395244e41e9befcab736cdae16388d8"
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
