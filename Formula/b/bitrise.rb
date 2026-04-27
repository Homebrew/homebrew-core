class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.39.4.tar.gz"
  sha256 "993af2634254a63a2cb35b876db5e1ddef05c78e3076eb7d8fa7c5bf9a040330"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a94e300ad4737f518b4b6acd1dd61f69955044ff7711f011294aebdd613ac95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a94e300ad4737f518b4b6acd1dd61f69955044ff7711f011294aebdd613ac95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a94e300ad4737f518b4b6acd1dd61f69955044ff7711f011294aebdd613ac95"
    sha256 cellar: :any_skip_relocation, sonoma:        "85694cd03794e91ab90bab2ecc4b2b0e435c70fdbdb334256a674d4358762211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d937c098863207816eb0f8aca46dfc65e7666a8304bcd861b6bf5ed33d44a375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e23cd1db234ae5eedb178c85000e71381599220501ba743a140ca01b97e6227"
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
