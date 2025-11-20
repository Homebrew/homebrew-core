class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.34.6.tar.gz"
  sha256 "530dd2a411f85a90261ab00f09bfad3d8a488e8bc7dc6df6b5179e596ee1c31a"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7db78585a9a785db9b747af1ee16baedbef451246a95d4ff75cdcf50e7a3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7db78585a9a785db9b747af1ee16baedbef451246a95d4ff75cdcf50e7a3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac7db78585a9a785db9b747af1ee16baedbef451246a95d4ff75cdcf50e7a3b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b2937a1b623f245159bb93b793cd2447d2ac6ff74a224033c0c9e9a509b4409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27594480129c3d965dac95352b1329a8204640cea5c1cf268e63db23090cc065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8b892dff5a84b517ec61b2901ee2f1cbfab92d91a84cecee7fc138f108c629"
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
