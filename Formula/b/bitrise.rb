class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.35.3.tar.gz"
  sha256 "9af5bf6bfa9444e859385278b423d5b990adeef0fbd304bfd7e0ec2119d6e237"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "619a028026e2c0e1a7988e2a16a5af0b3f5d394534c045dc11d42cd9ea18a5df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "619a028026e2c0e1a7988e2a16a5af0b3f5d394534c045dc11d42cd9ea18a5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619a028026e2c0e1a7988e2a16a5af0b3f5d394534c045dc11d42cd9ea18a5df"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9af948435369e6dbacf57a653cc744d462462894fab4b63acc2eb887648b18b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f8f5b179d78782f7f239f1e9abb43e4dce6cad785a6ebea1432487f7314dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2039a92015026aa0cb0b7901e85a6c0fbef6e03f2eb559d36573898657b4403"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
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
