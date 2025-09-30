class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.2.tar.gz"
  sha256 "f4dfb2c21f01de38193bfade81b5f6d0beb428f1d723ebb74d53ff5c95720ffb"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2228bb1ff5385bc16f84ea68a2d23fa97a4fbbdecbfbe261997b663b5accb360"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2228bb1ff5385bc16f84ea68a2d23fa97a4fbbdecbfbe261997b663b5accb360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2228bb1ff5385bc16f84ea68a2d23fa97a4fbbdecbfbe261997b663b5accb360"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2228bb1ff5385bc16f84ea68a2d23fa97a4fbbdecbfbe261997b663b5accb360"
    sha256 cellar: :any_skip_relocation, sonoma:        "25aefb7ef419cb4f4286ebf0bdc7ae48f506baec6d5a99daa5a71234f68a8ec5"
    sha256 cellar: :any_skip_relocation, ventura:       "25aefb7ef419cb4f4286ebf0bdc7ae48f506baec6d5a99daa5a71234f68a8ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2f0929fc27ea624044289c03a06c5044c295ea0e07989bacd9fde6f8dd3e0d"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
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
