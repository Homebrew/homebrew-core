class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "8d8399d3168bd97abc68e2fafdeac07bf59fed1afb162c19d1a30f87941cf6dc"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4526a4a4efbb4f5870901cbdf0e798f8ec5285c7d43da5762d4628bfb0fd626f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4526a4a4efbb4f5870901cbdf0e798f8ec5285c7d43da5762d4628bfb0fd626f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4526a4a4efbb4f5870901cbdf0e798f8ec5285c7d43da5762d4628bfb0fd626f"
    sha256 cellar: :any_skip_relocation, sonoma:        "400fbe8d63d1cbbf04ee80c99bb2d247057dd379a1a6b4324812c293e48cb76d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03040b7ec12e758a5b581e57979b5a7cedd5c99ef9508feeed1e8dc008d13b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9696562ee645e32c71243c065492ceffac2d4ceb7f1ea85253eda23cd6a3b5d"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
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
