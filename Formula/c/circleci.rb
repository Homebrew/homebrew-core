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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04957626c0015d20a371c78e10b859172e1b02b193549a74b592a1febe68537e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a52ae52a063dd730f770eae340005fb155ec54886eac47bc8a11a28e2b7eb13e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d77009490cb617bd50189db6caf25a546f6c927a13cc0555ef878eb5572ce47"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2604791eea6f295b40d070a76d6730e1aa342506442cb805a8bbbb3a57f7a362"
    sha256 cellar: :any,                 x86_64_linux:      "5af8f3cba7977181521a650fa6ee376ad5b7857760eb4a1c966851e3f74eab56"
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
