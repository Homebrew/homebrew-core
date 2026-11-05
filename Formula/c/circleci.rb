class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.14.0",
      revision: "81afef11190debc75248e2aa9ed4210f82bcd874"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e5d39ecafd6fc03447672c2f1f5913241b15665285ecba81953fe4138057a8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f961b42143f1ea9c98942c853efd21897dd63398b343ab1e1d42a6a9695bd51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b342ac8f0af6f15bcc60c1cd3a930da5bbe32724b78364a9ebb9762322f8613c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec6ed61a010bc69f382b1dbaa079eec1300a37c65f50e36f7accf2ecb0daef91"
    sha256 cellar: :any,                 x86_64_linux:      "86a0497276153a744aad1c60ad6092a4b1a09f397a15e8cf08398ea78532c766"
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
