class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.48.0.tar.gz"
  sha256 "0800d63eaca091f6570e227dec26560483ed6c74ea43558781fb717b5dfbdb42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef7aaf94c060b3d2f2e528d58ba566e41dbcd3e169e997d798b9d9a395d38884"
    sha256 cellar: :any_skip_relocation, big_sur:       "f84b6aac91c201586f7fee7320bda16245c0059bb07839d8bd9129fbcd09ba4d"
    sha256 cellar: :any_skip_relocation, catalina:      "201164203fa6dd3877110538b3195a31a5aa60b731de5312d6689406cf87b653"
    sha256 cellar: :any_skip_relocation, mojave:        "6da13e00379086989793cd50e3f5bd44ccd2c42355568ee807448efccdcd9543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117812c8112334d6aa34951b2836d5c22a7e573cd847d6a62fee5c46186097ae"
  end

  depends_on "go" => :build

  uses_from_macos "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
