class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.16.0",
      revision: "b21b157774b48255df75f12573d174200a572ddf"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e308483c3637fff4235eae8d72c63354ca8a6b05b70b6e4033468af52ac0986e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31232575547a664afef20d4363aa4e790fab0cb28263a38c4f4db8a8dc80e72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a6fa989406d792d635dbc0d8e5f415aec23308a2aabc423c45216f8087a4815"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7096569a4d0c84e8ecdbc5bb64fda8f17303056889c2ab870ed18cebfb61d2da"
    sha256 cellar: :any,                 x86_64_linux:      "da19049566223260785cbc6dfcd035c507b08e3e4ea80342fce6c64514ab0d6a"
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
