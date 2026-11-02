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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d92cf5b994c8ebc7d613436ebb319590356ce63634b558909d5cb013ed908cb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d92cf5b994c8ebc7d613436ebb319590356ce63634b558909d5cb013ed908cb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d92cf5b994c8ebc7d613436ebb319590356ce63634b558909d5cb013ed908cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7628082b5eada679ffea8572ce5de550fbc220ec77330d600df4a31af653f7d8"
    sha256 cellar: :any,                 x86_64_linux:      "f80065ed1504d7d275bf7cbe97ea914102a308dc8cdb12a97a46e70e0432c43d"
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
