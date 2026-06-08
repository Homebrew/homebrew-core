class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.4.tar.gz"
  sha256 "d71889130ce3f517bcc222899d2c9291ff391a737e06dd9d81b909969afbc06c"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85dd7e38548c7333e8ac9d5ba472e99786d5c2d1fa76ce5a9abd063e3f192fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85dd7e38548c7333e8ac9d5ba472e99786d5c2d1fa76ce5a9abd063e3f192fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85dd7e38548c7333e8ac9d5ba472e99786d5c2d1fa76ce5a9abd063e3f192fb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f5e564f09a880f60df55a031caf9de9f358788f5c1bb91b15b1331d826a88e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af2d77f64d1518af33c22c6eea5fc752a9335b0cc37e0c291565e6a643543c9"
    sha256 cellar: :any,                 x86_64_linux:  "90e7775029b20c1668f3380bc7c203b48e55da96377622aa1af38070c2f1c280"
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
