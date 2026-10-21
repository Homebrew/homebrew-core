class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "12f8ff23fb86dfc5b83515f6d1ca99a10cb6d4b4d1bb9aa6e5e0190781619bd3"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08d9f3716a0843663b7078615d4d2b42a8e1410573681a1237d1e65fb5cd6c1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08d9f3716a0843663b7078615d4d2b42a8e1410573681a1237d1e65fb5cd6c1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08d9f3716a0843663b7078615d4d2b42a8e1410573681a1237d1e65fb5cd6c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e074da0d95f9835cce8c6fcf314fbcdf7db06205fb0f62a979d87c87618bb9cb"
    sha256 cellar: :any,                 x86_64_linux:      "eac272d455ef0c33b9c21b8b651d25c21b6ae372960d635c741a734ccdeb0241"
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
