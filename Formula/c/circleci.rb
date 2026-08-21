class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.48692",
      revision: "8492ee467fd2a0a537efff57aff1c2f1e21c7395"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b35002d56f477346ca03bf2996f5bb3a628a934213113cefa8770d55c85b7716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ea4fc4d08a874b3f9c3953cae070a0f6e6f0b30a234ed3dce5e563d0c988b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95cfcefbe8fa9a9717938cea27e74ba5755b6ffd7ba58e2f227426acffd4b931"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d24c1cf36fc2e881a81e0a96f24bd64de1ba6b1b8938c13340a7094dc3cac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74416ba6107c01d89638e7e2eee227e73af2826d985cc200dba6fef5ef2747a8"
    sha256 cellar: :any,                 x86_64_linux:  "9ce2a939d0f193ecc872dc2dd450eb5cf11a1505eb65d19e79c75fbe83551adf"
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
