class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.2.tar.gz"
  sha256 "f2958c2e81692b19d1abcb724555d0d10fe7447444dd167d596ef565b87d914b"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f91fbaeaf4e2ab73f5d05970431905f2c10ef6117cce991efbcb62834cc03af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f91fbaeaf4e2ab73f5d05970431905f2c10ef6117cce991efbcb62834cc03af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f91fbaeaf4e2ab73f5d05970431905f2c10ef6117cce991efbcb62834cc03af"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bec84179a671467aa68347b623b06c8544548cb98ec59a95dfe7e6527524319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d226c249b396810d446f2e404f08cc74426ed4f4289dbf77dc9f4dc92227b021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e177482ee05c02a5df2046bc59afe8fce58d5b8d502c43b2c10d4187868dddb4"
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
