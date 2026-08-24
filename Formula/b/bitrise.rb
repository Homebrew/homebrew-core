class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.42.2.tar.gz"
  sha256 "da5de5c62b0563881d3210e36e7b05a77001eef3fde24442d0e7b17cfd84a0d6"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40583442e162cbae61e2400fe2fb779c1f0a3b7e0f4df6d618ec3aa555fbcba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40583442e162cbae61e2400fe2fb779c1f0a3b7e0f4df6d618ec3aa555fbcba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e40583442e162cbae61e2400fe2fb779c1f0a3b7e0f4df6d618ec3aa555fbcba"
    sha256 cellar: :any_skip_relocation, sonoma:        "51fe5585d5caf11ab44f1a561fc7f349e34be7d7afcfed87fff02e90a62f96ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13bb4a2954db0b22ebf3c248ab338dccf52872850cd31811b93f0a8ebc668842"
    sha256 cellar: :any,                 x86_64_linux:  "c22cc696708e46b28d090cafea0547e04ec36929e26955c5b43bf474e7f374e8"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
