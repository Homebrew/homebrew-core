class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.7.tar.gz"
  sha256 "c097b9c764db3fea347b14d0f02ee9df66b5680e7b8f618261d8409252aee21c"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ce4f62cfe5a06eac1e6660932389d9df99977061318be0d2590c05e6b17ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97ce4f62cfe5a06eac1e6660932389d9df99977061318be0d2590c05e6b17ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ce4f62cfe5a06eac1e6660932389d9df99977061318be0d2590c05e6b17ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e27adcb638317ca300d091bee22175c07c4046c38ff206ae83fa3e0e41bd0c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4fb46afae0daf1c661b38cb42ee3c02d0c3c863337a2271650f42c7a50ed341"
    sha256 cellar: :any,                 x86_64_linux:  "3b852b20e6c17fb849c87db43dcbb9dc79d8cdb4a0e54d544f7c5cc9771814d9"
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
