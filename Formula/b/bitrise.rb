class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "a9f7b2cc10857167c875124b301681b5fce02bacf52d02691943f9aba4025a57"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e66b1b3dee4c03a9bdcc20a63b0a13802aed26678c9930ecc70f5bca9aa476d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e66b1b3dee4c03a9bdcc20a63b0a13802aed26678c9930ecc70f5bca9aa476d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e66b1b3dee4c03a9bdcc20a63b0a13802aed26678c9930ecc70f5bca9aa476d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f34589353ade8562ad105fafaccc35f9eebd224f95d3e37af61995a8933a6549"
    sha256 cellar: :any,                 x86_64_linux:      "2709700be0fca127d0fab21eb0e18068b664171db6c3dceccc62fe67ab494639"
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
