class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "7b96a040bc58108cf750e4d64a38923cb47f41352959e355ee3afe78cbd545f0"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccb95df88317a58550059f87582695064d68f54305461fcfdb1ad8809e005a22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ccb95df88317a58550059f87582695064d68f54305461fcfdb1ad8809e005a22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ccb95df88317a58550059f87582695064d68f54305461fcfdb1ad8809e005a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "880841f8a631eacb8eded75974cca4ca4ec71319055acbeaf7481d987b56221a"
    sha256 cellar: :any,                 x86_64_linux:      "2e06e51834f845ba48180b17cd084f98c0867763d59dde8eb10a57d1466d3bfa"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  # Test downloads the envman and stepman tools and the step library
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
