class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.36.5.tar.gz"
  sha256 "bebe5a338fcf87340f46375b25f90b42473a470a2c1a9aead991b33bee51840b"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d42b49811d5a75d186e79d9ea8ec67bf635aa9df69b984f5eed8f900f8117970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d42b49811d5a75d186e79d9ea8ec67bf635aa9df69b984f5eed8f900f8117970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d42b49811d5a75d186e79d9ea8ec67bf635aa9df69b984f5eed8f900f8117970"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce11b29d5eeb7d4ddaba68994fa15b7d08ee4d2438086dfa6f3b02c8a6ecab59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5064e1c8c2ed3ce7941f0fed7023bcc6437db1c0453ed7b9ea03714ba88e9dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038c815bd7be1ef002e408120ab06ae3d1dc4c9668da0e5b65c6caa76849257a"
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
