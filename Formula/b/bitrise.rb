class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "ea3d946da61e1fb0e81942c39c9a7b41e50a122d13ada5b0fed11fdc4487f416"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7374724242e9a3a51a7f62f8fca9d4aae00214c2c4ffeea68a98e1c169e3b155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7374724242e9a3a51a7f62f8fca9d4aae00214c2c4ffeea68a98e1c169e3b155"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7374724242e9a3a51a7f62f8fca9d4aae00214c2c4ffeea68a98e1c169e3b155"
    sha256 cellar: :any_skip_relocation, sonoma:        "6993c78d9917c0689e2e9302a9e8413c9b7db30030286896acd32cac501592f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720981b0676eb4c64e48ba5147abd451fb2d4b2fbf385f164153c71fd89aa600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b7ddb368293dc0e9ad03bf5af1d552a0383c9f68ec92b3dce8b38bafaf46b0"
  end

  depends_on "go" => [:build, :test]

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
