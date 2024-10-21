class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/2.22.2.tar.gz"
  sha256 "f2c3b3628260606c0d09437c54c0fa42b38ba86601038373df2b04672621dc19"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "846c3c2449fdf9e61f3bf45a4c99869cbaa2f6347f8f6ff54165dc2568dbda09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "846c3c2449fdf9e61f3bf45a4c99869cbaa2f6347f8f6ff54165dc2568dbda09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "846c3c2449fdf9e61f3bf45a4c99869cbaa2f6347f8f6ff54165dc2568dbda09"
    sha256 cellar: :any_skip_relocation, sonoma:        "566b4a7b665b613afd2327252213a8277404d02d4005d141c0e5dc083638eb30"
    sha256 cellar: :any_skip_relocation, ventura:       "566b4a7b665b613afd2327252213a8277404d02d4005d141c0e5dc083638eb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c139bb772527e8bf303a63c492976d067ac6acfd2d068c45228652b167a3b96"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/version.VERSION=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
