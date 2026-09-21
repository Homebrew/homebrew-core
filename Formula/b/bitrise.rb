class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "16d9183e0c65e626eac52f5960ae18130cb3d5de068800dd79e553b5808219c9"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7537d0df43b2a808db78e64b626e6ea0d1b16559ed6b51d37cd70c0db22bc7f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7537d0df43b2a808db78e64b626e6ea0d1b16559ed6b51d37cd70c0db22bc7f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7537d0df43b2a808db78e64b626e6ea0d1b16559ed6b51d37cd70c0db22bc7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0cef66ee6d5fc308bafadefe66ab0a2ddb2df76a5cb492a64c1c1f50c2bf884"
    sha256 cellar: :any,                 x86_64_linux:      "460ebf3a594e036e6f5fa1b7e4a0154ceb7079ef854abae6154672259332a8d0"
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
