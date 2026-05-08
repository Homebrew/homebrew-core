class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.5.tar.gz"
  sha256 "65781686de66892f78290ed0a62bdb731313c729637ffa82bef4b3e389ac5bad"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c3b5a5ebc867939d310cea77e7dad92c3e8b34499e2e4b99739d90c843b52f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c3b5a5ebc867939d310cea77e7dad92c3e8b34499e2e4b99739d90c843b52f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3b5a5ebc867939d310cea77e7dad92c3e8b34499e2e4b99739d90c843b52f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "61c142077fec04d2cdc75ec31ad89a6695eab5b06c549fdb60e0af1cb2e2dd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b76bc062e8e90ebaf4794196b218df0e45cbfacd952b588a73640b918328035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d843adb9d719715e952ed391855d13b149ba7d65aa252721e99b77aaaba0e908"
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
