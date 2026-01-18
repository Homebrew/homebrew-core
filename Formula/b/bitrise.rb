class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.36.3.tar.gz"
  sha256 "65351f86cf713cafa4a3290df65f8551d56c42ea3ead090a0b2bea1ee8f488ac"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b73ab486c7d8da655c26fcb3236f1ad5abff56db9920320b83fefc07f79d8086"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b73ab486c7d8da655c26fcb3236f1ad5abff56db9920320b83fefc07f79d8086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73ab486c7d8da655c26fcb3236f1ad5abff56db9920320b83fefc07f79d8086"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a2bac0c914bb772b96f2afe85be24550d0ebb9a816f6601d54a4d15747320be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c473447395f57d71c077771407eb2550bc881a35ad13b22557a8bfbfb3bbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0200fbcc673cec336abe6f03f70399956db7685b7d1c6a0b4430e448399249b"
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
