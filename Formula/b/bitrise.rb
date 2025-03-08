class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.30.1.tar.gz"
  sha256 "fac8dc02f74fee90bcd0e36c38df46cc72e0b97a9da4929336d52545a121fa97"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b88cb2630e816cc22bc932a7646cd1309911ed0b4fdef38d26cd5103ecef88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34b88cb2630e816cc22bc932a7646cd1309911ed0b4fdef38d26cd5103ecef88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34b88cb2630e816cc22bc932a7646cd1309911ed0b4fdef38d26cd5103ecef88"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b636a994bb3c8cfd1ebefd9f0afba0f54ef17f31fe0f46c411af3b3043935e"
    sha256 cellar: :any_skip_relocation, ventura:       "b7b636a994bb3c8cfd1ebefd9f0afba0f54ef17f31fe0f46c411af3b3043935e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b966e007d0cebfbb37f17cca0f0335fdb9ee45dd7838b40f1139ac29549dd7"
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
