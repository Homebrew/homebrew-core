class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50428",
      revision: "366c9a20e158e1e16dcf69bbe65d6dd75a2b61a5"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bc84e8dbe26dc74e4452589983d49cca341ac04af610c2736810932fdb915f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff034f93b6495332fbb8c14f3831879ce1751b66cd14ce9d19eafdc543dad251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "117af1eb08e9e32af491828a44593654e667ba4d2d8b90012d9e0051ec28a5cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbae1dc453eebb936ecb64081bf876482bd095a3f5c3327a80ef4e2b000a74fb"
    sha256 cellar: :any,                 x86_64_linux:      "1e87cab1847dddfcc5f8c0f7e7e01ee1909c797cdeebc87b01c699889f862348"
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
